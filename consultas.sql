// Recupere todos os dependentes do sexo feminino
select * from dependente where sexo = 'F';

// Recupere o nome e o endereço de todos os funcionarios que trabalham no departamento 'Administracao'.
// Colunas esperadas (renomeamento se necessário): pnome, endereco
select pnome, endereco from funcionario where dnr = (select dnumero from departamento where dnome = 'Administracao');

// Recupere o nome de todos os funcionários do departamento 5 
select pnome from funcionario where dnr = 5;

// Recupere o nome de todos os projeto do departamento 5 ou 1
// Ordene pelo nome do projeto de forma crescente
select projnome from projeto where dnum = 5 or dnum = 1;

// Liste as informações dos funcionarios que trabalham para o departamento 4 e que recebem salário maior do que R$25.000,00 ou que trabalham para o departamento 5 e que recebem salário maior do que R$30.000,00
// Colunas esperadas: pnome, salario, dnr 
// Ordene pelo nome do funcionario de forma crescente
select pnome, salario, dnr from funcionario where dnr = 4 and
salario > 25000 or dnr = 5 and salario > 30000
ORDER BY pnome;

// Liste o nome do funcionário, seu departamento, o nome do seu supervisor e o departamento do supervisor, considerando todos os funcionários que trabalham para o departamento 5 ou que são supervisionados por supervisores que trabalham no departamento 5;
// Colunas esperadas: nome_funcionario, dep_funcionario, nome_supervisor, dep_supervisor
// Ordene pelo nome do funcionario de forma crescente
select f.pnome as nome_funcionario, f.dnr as dep_funcionario, s.pnome as nome_supervisor, s.dnr as dep_supervisor from funcionario f, funcionario s
where s.cpf=f.cpf_supervisor and f.dnr=5 or s.cpf=f.cpf_supervisor and s.dnr = 5
ORDER BY f.pnome; 

// Liste o cpf dos funcionários que são gerentes e supervisores (INTERSECT)
select cpf from funcionario
intersect
select cpf_gerente from departamento;

// Liste o cpf dos funcionários que não possuem dependentes (utilize EXCEPT)
select cpf from funcionario
except
select cpf from funcionario, dependente where funcionario.cpf = dependente.fcpf;

// Liste o cpf dos funcionarios que trabalham para o departamento 5 ou que supervisionam um empregado que trabalha para o departamento 5. Ordene  de forma ascendente. (utilize UNION)
select cpf from funcionario where dnr = 5
union
select s.cpf from funcionario f, funcionario s where f.cpf_supervisor=s.cpf and f.dnr = 5;

// Para cada funcionário, recupere o primeiro e o último nome do funcionário e o primeiro e o último nome  de seus supervisor imediato.
// Colunas esperadas: funcionario.pnome, funcionario.unome, supervisor.pnome, supervisor.unome 
select f.pnome, f.unome, s.pnome, s.unome from funcionario f inner join funcionario s on (f.cpf_supervisor = s.cpf);

// Retorne  pnome do funcionário e de seu supervisor. Liste todos os funcionários, mesmo aqueles que não possuem supervisor.
// Colunas esperadas: nome_funcionario, nome_supervisor
// Observação: SQLite não implementa: RIGHT JOIN, FULL JOIN
select f.pnome, s.pnome from funcionario f left join funcionario s on (f.cpf_supervisor = s.cpf)
union all
select f.pnome, s.pnome from funcionario s left join funcionario f on (f.cpf_supervisor = s.cpf) 
where f.cpf_supervisor is null and f.pnome is not null;

// Listar todos os departamentos e seus respectivos funcionários. Listar também aqueles departamentos que não possuem funcionário.
// Colunas esperadas: pnome, unome, endereco, dnome, dnumero
// Observação: SQLite não implementa: RIGHT JOIN, FULL JOIN
select pnome, unome, endereco, dnome, dnumero from funcionario left join departamento on (dnr = dnumero)
union all
select pnome, unome, endereco, dnome, dnumero from departamento left join funcionario on (dnr = dnumero);

// Listar todos os departamentos combinados com todos os funcionários. 
// Ordene de forma ascendente por nome do departamento e nome do funcionário respectivamente.
// Colunas esperadas: dnome, dnumero, pnome, unome
select dnome, dnumero, pnome, unome 
from departamento cross join funcionario
order by dnome asc, pnome asc;

// Liste os nomes dos funcionários, as horas trabalhadas e o nome dos projetos que os funcionários trabalharam e são controlado pelo departamento número 5
// Colunas esperadas: pnome, unome, horas, projnome
// Ordernação: pnome e projnome crescente
select pnome, unome, horas, projnome
from funcionario join trabalha_em on (cpf=fcpf)
join projeto on (pnr=projnumero)
where dnum=5
order by pnome asc, projnome asc;

// Qual o maior salário, o menor salário e a média de salários na relação funcionário por supervisor?
// Colunas esperadas: cpf_supervisor, menor_salario, maior_salario, media_salarios
// Observação: utilize a função round(atributo, numero_casas_decimais) para arredondar para duas casas decimais.
select 
cpf_supervisor,
round(min(salario), 2) as menor_salario,
round(max(salario), 2) as maior_salario,
round(avg(salario), 2) as media_salarios
from funcionario
group by cpf_supervisor;

// Qual o maior salário, o menor salário e a média de salários na relação funcionário por supervisor, para médias salariais superiores a 30000?
// Colunas esperadas: cpf_supervisor, menor_salario, maior_salario, media_salarios
select 
cpf_supervisor,
round(min(salario), 2) as menor_salario,
round(max(salario), 2) as maior_salario,
round(avg(salario), 2) as media_salarios
from funcionario
group by cpf_supervisor
having avg(salario)>30000;

// Listar os nomes de todos os funcionários com dois ou mais dependentes
// Colunas esperadas: pnome, qtd_dependentes
select
pnome,
count(fcpf) as qtd_dependentes
from funcionario, dependente
where cpf=fcpf
group by pnome
having count(fcpf)>2;

// Recupere o cpf e nome dos gerentes que possuam ao menos dois dependente.
// UTILIZE IN / NOT IN
// Colunas esperadas: cpf, pnome, unome
// Ordenação: cpf (ascendente)
select cpf, pnome, unome 
from funcionario join dependente on (cpf=fcpf)
where cpf in (select cpf_gerente from departamento)
group by cpf, pnome, unome
having count(cpf) >= 2
order by cpf asc;

// Recupere os funcionários que não possuem dependentes
// UTILIZE IN / NOT IN
// Colunas esperadas: todos os atributos de funcionário
// Ordenação: primeiro atributo desc
select *
from funcionario
where cpf not in (select fcpf from dependente)
order by 1 desc;

// Recupere os funcionários que não possuem dependentes
// UTILIZE EXISTS /NOT EXISTS
// Colunas esperadas: todos os atributos de funcionário
// Ordenação: primeiro atributo desc
select *
from funcionario
where not exists (select * from dependente
where cpf=fcpf)
order by 1 desc;

// Recupere o segundo maior salario dos funcionários
// Colunas esperadas: segundo_maior_salario
select max(salario) as segundo_maior_salario
from funcionario
where salario < (select MAX(salario) from funcionario);

// Crie a visão a qual recupera o primeiro nome e o sobrenome dos funcionários ,  o nome do projeto e as horas trabalhadas em cada projeto, somente se o projeto for localizado em 'Stanford'. Após a definição da VIEW, crie um comando SQL que liste todos os atributos da view definida.
// Nome da view vfuncionario_projeto
// Colunas esperadas: pnome, unome, projnome, horas 
// IMPORTANTE: 
// Não utilize OR REPLACE na definição da view 
create view vfuncionario_projeto as
select pnome, unome, projnome, horas
from funcionario join trabalha_em on (cpf=fcpf)
join projeto on (pnr=projnumero)
where projlocal = 'Stanford';
select * from vfuncionario_projeto;

// Crie uma view que retorna o nome do departamento, o tipo de profissional ("funcionario simples", "gerente", "supervisor", "gerente e supervisor" ao mesmo tempo), o número do departamento e a quantidade de cada um desses profissionais para cada departamento. Após a definição da VIEW, crie um comando SQL que liste todos os atributos da view definida.
// Colunas esperadas: nome_depto, tipo, dnumero, qtd_profissionais
// Ordenação: nome_depto ascendente e tipo ascendente
// Nome da view: vdep_tipofunc
// IMPORTANTE: 
// Não utilize OR REPLACE na definição da view 
// Utilize apenas a estrutura abaixo (1 view completa + 1 select que consulta a view definida):
// CREATE VIEW vdep_tipofunc AS
// <consulta>;
// SELECT * FROM vdep_tipofunc;
--- Expected output (exact text)---
>Administracao|funcionario simples|4|4
>Administracao|gerente e supervisor|4|1
>Computacao|funcionario simples|5|2
>Computacao|gerente e supervisor|5|1
>Computacao|supervisor|5|1
>Sede_administrativa|gerente e supervisor|1|1
>Sede_administrativa|supervisor|1|1