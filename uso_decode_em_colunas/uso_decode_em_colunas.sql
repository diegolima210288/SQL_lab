select
    c.nm_pessoa_fisica as profissional
    ,e.nr_prontuario as rghc
    ,a.dt_avaliacao
    ,a.qt_peso_habit as peso_habitual
    ,a.qt_peso_atual as peso_atual
    ,a.qt_perda as perda_kg
    ,a.pr_perda as pc_perda
    ,a.qt_semanas_ingestao as duracao
    ,a.qt_semanas_capacidade as duracao
    ,e.ie_sexo as sexo_pac
    ,trunc((trunc(sysdate) - e.dt_nascimento)/360) as idade
    ,d.nr_atendimento
    ,d.dt_entrada as entrada_atend
    ,a.ds_resultado as ds_av_nut
    ,f.cd_doenca_cid as cid_diag
    ,substr(f.cd_doenca_cid || ' - '|| obter_desc_cid(f.cd_doenca_cid),1,255) as desc_cid_diag
    ,substr(obter_nome_setor(g.cd_setor_atendimento),1,40) as setor
    ,g.cd_unidade_basica as unidade
--uso da fun��o DECODE, para apresentar a descri��o do valor de cada coluna
    ,decode(a.ie_mudou_peso,'S','Sim','N�o') as mudou_peso
    ,decode(a.ie_mudanca_dieta,'S','Sim','N�o') as mudanca_dieta
    ,decode(a.ie_dieta_hipocalorica,'S','Sim','N�o') as dieta_hipoc
    ,decode(a.ie_dieta_pastosa_hipocalorica,'S','Sim','N�o') as die_past_hipoc
    ,decode(a.ie_diet_liquida,'S','Sim','N�o') as diet_liquida
    ,decode(a.ie_jejum,'S','Sim','N�o') as jejum
    ,decode(a.ie_mudanca_persistente,'S','Sim','N�o') as mudanca_persistente
    ,decode(a.ie_anorexia,'S','Sim','N�o') as anorexia
    ,decode(a.ie_vomito,'S','Sim','N�o') as vomito
    ,decode(a.ie_nausea,'S','Sim','N�o') as nausea
    ,decode(a.ie_diarreia,'S','Sim','N�o') as diarreia
    ,decode(a.ie_perda_gordura,0,'Normal',2,'Moderada',1,'Leve',3,'Grave') as gord_subc
    ,decode(a.ie_musculo_estriado,0,'Normal',2,'Moderada',1,'Leve',3,'Grave') as perda_mas_musc
    ,decode(a.ie_edema_tornozelo,0,'Normal',2,'Moderada',1,'Leve',3,'Grave') as edema_torn
    ,decode(a.ie_edema_sacral,0,'Normal',2,'Moderada',1,'Leve',3,'Grave') as edema_sacral
    ,decode(a.ie_ascite,0,'Normal',2,'Moderada',1,'Leve',3,'Grave') as ascite
from aval_nutric a
--jun��es para apresentar nome do profissional
    inner join pessoa c
        on a.cd_profissional = c.cd_pessoa_fisica
--jun��es para apresentar dados do paciente
    inner join atendimento d
        on a.nr_atendimento = d.nr_atendimento
    inner join pessoa e
        on d.cd_pessoa_fisica = e.cd_pessoa_fisica
--jun��o para apresentar o CID
    inner join loco_regional f
        on e.cd_pessoa_fisica = f.cd_pessoa_fisica
--jun��o para apresentar o setor do paciente
    inner join atend_unidade g
        on d.nr_atendimento = g.nr_atendimento
    inner join (select max(dt_entrada_unidade) dt_entrada_unidade, nr_atendimento
                from atend_unidade
                where cd_tipo_acomodacao = 9
                group by nr_atendimento) base
        on g.nr_atendimento = base.nr_atendimento
        and g.dt_entrada_unidade = base.dt_entrada_unidade
--condi��es e filtros
where a.dt_liberacao is not null
    and a.dt_inativacao is null
    and a.ie_tipo_avaliacao = 'A'
    and trunc(a.dt_avaliacao) between &dt_inicio and &dt_fim
    and (a.cd_profissional = &cd_profissional or &cd_profissional = 0);