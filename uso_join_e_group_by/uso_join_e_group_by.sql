select
    e.sg_estado,
    sum(decode(p.ie_sexo,'f',1,0)) mulher,
    sum(decode(p.ie_sexo,'m',1,0)) homem
from pessoa p
    inner join endereco e
        on p.cd_pessoa = e.cd_pessoa
        and e.tp_endereco = 1
group by e.sg_estado
order by mulher desc, homem desc;