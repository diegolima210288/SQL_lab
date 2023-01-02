select
    a.cd_pessoa,
    a.nm_pessoa,
    a.cd_cargo,
    c.ds_cargo,
    a.dt_admissao_hosp,
    a.dt_demissao_hosp,
    obter_idade(a.dt_nascimento,sysdate,'A')idade,
    a.nr_seq_chefia,
    e.ds_chefia,
--uso da função DECODE, para apresentar descritivo SEXO
    decode(a.ie_sexo, 'M', 'Masculino', 'Feminino') sexo,
    a.cd_municipio_ibge,
    g.ds_municipio,
    f.ds_nacionalidade,
    a.nr_telefone_celular,
    h.ds_email,
--uso da função CASE, para verificar se funcionario esta Ativo ou Demitido
    case 
        when a.dt_demissao_hosp is null then 'Ativo'
        when a.dt_demissao_hosp is not null then 'Demitido'
    end cd_situacao,
    h.cd_cep,
    a.nr_pis_pasep,
    a.nr_cartao_nac_sus cns,
    a.dt_nascimento as dt_nasc,
    substr(obter_nome_terceiro(nr_seq_terceiro),1,255) terceiro
--junções de tabelas
from pessoa a
    inner join cargo c
        on a.cd_cargo = c.cd_cargo
    left join chefia_pf e
        on a.nr_seq_chefia = e.nr_sequencia
    left join nacionalidade f
        on a.cd_nacionalidade = f.cd_nacionalidade
    left join municipio g
        on a.cd_municipio_ibge = g.cd_municipio_ibge
    left join compl_end h
        on a.cd_pessoa_fisica = h.cd_pessoa_fisica
        and h.ie_tipo_complemento = 1
--condições e filtros
where a.ie_funcionario = 'S'
    and a.ie_vinculo_profissional <> 1
    and
    (case 
        when a.dt_demissao_hosp is null then '0'
        when a.dt_demissao_hosp is not null then '1'
    end) = &situacao
    and (a.cd_cargo = &cd_cargo or &&cd_cargo = 0)
    and (a.nr_seq_chefia = &nr_seq_chefia or &&nr_seq_chefia = 0)
    and (a.ie_vinculo_profissional = &ie_vinculo or &&ie_vinculo = 0);