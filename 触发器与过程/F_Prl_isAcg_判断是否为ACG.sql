create or replace function F_Prl_isAcg(p_AcgGid varchar2 --FlowGid
                                       ) return number is
  v_Ret int; --·µ»ØÖµ
begin
  select count(*)
    into v_Ret
    from prl_acg
   where gid = p_AcgGid
     and code in ('1.01', '1.02', '1.03', '1.04', '1.05', '1.06', '8.02');
  return v_Ret;
end;
/
