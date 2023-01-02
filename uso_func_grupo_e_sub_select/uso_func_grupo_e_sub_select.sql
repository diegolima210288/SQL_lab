select
    x.ano,
    prescricao.quant prescricao,
    caio.quant caio,
    ambulatorio.quant ambulatorio, 
    aval_pre_cirur.quant aval_pre_cirur,
    internacao.quant internacao,
    res_alta.quant res_alta,
    diag_tumor.quant diag_tumor,
    hist_saude.quant hist_saude,
    parec_medico.quant parec_medico,
    ganhos_perdas.quant ganhos_perdas,
    sae.quant sae,
    saps.quant saps,
    consentimento.quant consentimento,
    receitas.quant receitas
from 
(select 2018 ano from dual
union all
select 2019 ano from dual) x
--prescricao
    left join (select
                    to_char(dt_prescricao, 'yyyy') ano,
                    count(1) quant
                from prescricoes pm
                where to_char(dt_prescricao, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where pm.nr_seq_assinatura = tadl.nr_seq_assinatura)
                group by to_char(dt_prescricao, 'yyyy')) prescricao
        on x.ano = prescricao.ano
--PS
    left join (select
                    a.ano,
                    b.quant + c.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(er.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from registros er
                                where to_char(er.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where er.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                    and er.nr_seq_item_pront = 83
                                group by to_char(er.dt_registro, 'yyyy')) b
                        on a.ano = b.ano
                    inner join (select
                                    to_char(ap.dt_ananmese, 'yyyy') ano,
                                    count(1) quant
                                from anamnese_paciente ap
                                where to_char(ap.dt_ananmese, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where ap.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(ap.dt_ananmese, 'yyyy')) c
                        on a.ano = c.ano) caio
    on x.ano = caio.ano
--ambulatorio
    left join (select
                    a.ano,
                    b.quant + c.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(er.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from registros er
                                where to_char(er.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where er.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                    and er.nr_seq_item_pront = 884
                                group by to_char(er.dt_registro, 'yyyy')) b
                        on a.ano = b.ano
                    inner join (select
                                    to_char(aa.dt_atendimento, 'yyyy') ano,
                                    count(1) quant
                                from ambulatorial aa
                                where to_char(aa.dt_atendimento, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where aa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(aa.dt_atendimento, 'yyyy')) c
                        on a.ano = c.ano) ambulatorio
    on x.ano = ambulatorio.ano
--avaliações pré-cirurgica
    left join (select
                    a.ano,
                    b.quant + c.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(er.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from registros er
                                where to_char(er.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where er.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                    and er.nr_seq_item_pront = 7
                                group by to_char(er.dt_registro, 'yyyy')) b
                        on a.ano = b.ano
                    inner join (select
                                    to_char(map.dt_avaliacao, 'yyyy') ano,
                                    count(1) quant
                                from med_avaliacao_paciente map
                                where to_char(map.dt_avaliacao, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where map.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(map.dt_avaliacao, 'yyyy')) c
                        on a.ano = c.ano) aval_pre_cirur
    on x.ano = aval_pre_cirur.ano
--internação
    left join (select
                    a.ano,
                    b.quant + c.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(er.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from registros er
                                where to_char(er.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where er.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                    and er.nr_seq_item_pront = 5
                                group by to_char(er.dt_registro, 'yyyy')) b
                        on a.ano = b.ano
                    inner join (select
                                    to_char(ep.dt_evolucao, 'yyyy') ano,
                                    count(1) quant
                                from evolucao ep
                                where to_char(ep.dt_evolucao, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where ep.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(ep.dt_evolucao, 'yyyy')) c
                    on a.ano = c.ano) internacao
    on x.ano = internacao.ano
--resumo de alta
    left join (select
                    a.ano,
                    b.quant + c.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(er.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from registros er
                                where to_char(er.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where er.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                    and er.nr_seq_item_pront = 153
                                group by to_char(er.dt_registro, 'yyyy')) b
                        on a.ano = b.ano 
                    inner join (select
                                    to_char(aa.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from atendimento_alta aa
                                where to_char(aa.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where aa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(aa.dt_registro, 'yyyy')) c
                        on a.ano = c.ano) res_alta
    on x.ano = res_alta.ano
--alta institucional / especialidade
    left join (select
                    to_char(er.dt_registro, 'yyyy') ano,
                    count(1) quant
                from registros er
                where to_char(er.dt_registro, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where er.nr_seq_assinatura = tadl.nr_seq_assinatura)
                    and er.nr_seq_item_pront = 1173
                group by to_char(er.dt_registro, 'yyyy')) alt_inst
    on x.ano = alt_inst.ano
--diagnóstico do tumor
    left join (select
                    to_char(clr.dt_avaliacao, 'yyyy') ano,
                    count(1) quant
                from loco_regional clr
                where to_char(clr.dt_avaliacao, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where clr.nr_seq_assinatura = tadl.nr_seq_assinatura)
                group by to_char(clr.dt_avaliacao, 'yyyy')) diag_tumor
    on x.ano = diag_tumor.ano
--histórico saude
    left join (select
                    a.ano,
                    b.quant + c.quant + d.quant + e.quant + f.quant + g.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(pa.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from paciente_alergia pa
                                where to_char(pa.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pa.dt_registro, 'yyyy')) b
                        on a.ano = b.ano 
                    inner join (select
                                    to_char(pa.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from paciente_antec_clinico pa
                                where to_char(pa.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pa.dt_registro, 'yyyy')) c
                        on a.ano = c.ano 
                    inner join (select
                                    to_char(pa.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from paciente_medic_uso pa
                                where to_char(pa.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pa.dt_registro, 'yyyy')) d
                        on a.ano = d.ano 
                    inner join (select
                                    to_char(pa.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from paciente_habito_vicio pa
                                where to_char(pa.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pa.dt_registro, 'yyyy')) e
                        on a.ano = e.ano 
                    inner join (select
                                    to_char(pa.dt_atualizacao_nrec, 'yyyy') ano,
                                    count(1) quant
                                from historico_saude_cir pa
                                where to_char(pa.dt_atualizacao_nrec, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pa.dt_atualizacao_nrec, 'yyyy')) f
                        on a.ano = f.ano 
                    inner join (select
                                    to_char(pa.dt_registro, 'yyyy') ano,
                                    count(1) quant
                                from paciente_acessorio pa
                                where to_char(pa.dt_registro, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pa.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pa.dt_registro, 'yyyy')) g
                        on a.ano = g.ano) hist_saude
    on x.ano = hist_saude.ano
--parecer medico e interconsulta
    left join (select
                    a.ano,
                    b.quant + c.quant quant
                from 
                (select 2018 ano from dual
                union all
                select 2019 ano from dual) a
                    inner join (select
                                    to_char(pmr.dt_atualizacao_nrec, 'yyyy') ano,
                                    count(1) quant
                                from parecer_medico_req pmr
                                where to_char(pmr.dt_atualizacao_nrec, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pmr.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pmr.dt_atualizacao_nrec, 'yyyy')) b
                        on a.ano = b.ano 
                    inner join (select
                                    to_char(pm.dt_atualizacao_nrec, 'yyyy') ano,
                                    count(1) quant
                                from parecer_medico pm
                                where to_char(pm.dt_atualizacao_nrec, 'yyyy') in (2018,2019)
                                    and exists (select 1
                                                from assinat_dig_log tadl
                                                where pm.nr_seq_assinatura = tadl.nr_seq_assinatura)
                                group by to_char(pm.dt_atualizacao_nrec, 'yyyy')) c
                        on a.ano = c.ano) parec_medico
    on x.ano = parec_medico.ano
--sinais vitais
    left join (select
                    to_char(asv.dt_sinal_vital, 'yyyy') ano,
                    count(1) quant
                from atendimento_sinal_vital asv
                where to_char(asv.dt_sinal_vital, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where asv.nr_seq_assinatura = tadl.nr_seq_assinatura)
                group by to_char(asv.dt_sinal_vital, 'yyyy')) sinais_vit
    on x.ano = sinais_vit.ano
--ganhos e perdas
    left join (select
                    to_char(apg.dt_medida, 'yyyy') ano,
                    count(1) quant
                from perda_ganho apg
                where to_char(apg.dt_medida, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where apg.nr_seq_assinatura = tadl.nr_seq_assinatura)
                group by to_char(apg.dt_medida, 'yyyy')) ganhos_perdas
    on x.ano = ganhos_perdas.ano
--prescrição enfermagem
    left join (select
                    to_char(pp.dt_prescricao, 'yyyy') ano,
                    count(1) quant
                from pe_prescricao pp
                where to_char(pp.dt_prescricao, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where pp.nr_seq_assinatura = tadl.nr_seq_assinatura)
                    and pp.ie_tipo = 'SAE'
                group by to_char(pp.dt_prescricao, 'yyyy')) sae
    on x.ano = sae.ano
--recomendações pós alta
    left join (select
                    to_char(pp.dt_prescricao, 'yyyy') ano,
                    count(1) quant
                from pe_prescricao pp
                where to_char(pp.dt_prescricao, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where pp.nr_seq_assinatura = tadl.nr_seq_assinatura)
                    and pp.ie_tipo = 'SAPS'
                group by to_char(pp.dt_prescricao, 'yyyy')) saps
    on x.ano = saps.ano
--Consentimento
    left join (select
                    to_char(ppc.dt_atualizacao_nrec, 'yyyy') ano,
                    count(1) quant
                from pep_pac_ci ppc
                where to_char(ppc.dt_atualizacao_nrec, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinat_dig_log tadl
                                where ppc.nr_seq_assinatura = tadl.nr_seq_assinatura)
                group by to_char(ppc.dt_atualizacao_nrec, 'yyyy')) consentimento
    on x.ano = consentimento.ano
--Receitas
    left join (select
                    to_char(frf.dt_receita, 'yyyy') ano,
                    count(1) quant
                from fa_receita_farmacia frf
                where to_char(frf.dt_receita, 'yyyy') in (2018,2019)
                    and exists (select 1
                                from assinatura_digital tad
                                where frf.nr_seq_assinatura_parcial = tad.nr_sequencia)
                group by to_char(frf.dt_receita, 'yyyy')) receitas
    on x.ano = receitas.ano;


