update wf_task t
   set (t.code) =
       (select d.code
          from wf_task_define d
         where d.entgid = t.entgid
           and d.modelgid = t.modelgid
           and d.taskdefgid = t.taskdefgid)
 where t.entgid = getentgid
   and exists (select d.code
          from wf_task_define d
         where d.entgid = t.entgid
           and d.modelgid = t.modelgid
           and d.taskdefgid = t.taskdefgid
           and lower(d.code) != lower(t.code));
           
update wf_task_history t
   set (t.code) =
       (select d.code
          from wf_task_define d
         where d.entgid = t.entgid
           and d.modelgid = t.modelgid
           and d.taskdefgid = t.taskdefgid)
 where t.entgid = getentgid
   and exists (select d.code
          from wf_task_define d
         where d.entgid = t.entgid
           and d.modelgid = t.modelgid
           and d.taskdefgid = t.taskdefgid
           and lower(d.code) != lower(t.code));
