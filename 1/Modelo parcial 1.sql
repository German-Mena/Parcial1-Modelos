Use MODELOPARCIAL1

-- Apellido y nombres de los pacientes cuya cantidad de turnos de 'Protologia' sea mayor a 2.

-- Usando subconsultas
select CONCAT(P.NOMBRE,' ',P.APELLIDO) as Pacientes
from PACIENTES as P
where (
	select count(P2.IDPACIENTE) from PACIENTES as P2
	inner join Turnos as T on T.IDPACIENTE = P2.IDPACIENTE
	inner join MEDICOS as M on M.IDMEDICO = T.IDMEDICO
	inner join ESPECIALIDADES as E on E.IDESPECIALIDAD = M.IDESPECIALIDAD
	where P.IDPACIENTE = P2.IDPACIENTE and E.NOMBRE like 'Proctologia'
) > 2
order by Pacientes asc


-- Sin subconsultas
select distinct CONCAT(P.NOMBRE,' ',P.APELLIDO) as Pacientes
from PACIENTES as P
	inner join Turnos as T on T.IDPACIENTE = P.IDPACIENTE
	inner join MEDICOS as M on M.IDMEDICO = T.IDMEDICO
	inner join ESPECIALIDADES as E on E.IDESPECIALIDAD = M.IDESPECIALIDAD
where E.NOMBRE like 'Proctologia'
group by CONCAT(P.NOMBRE,' ',P.APELLIDO)
having count(P.IDPACIENTE) > 2
order by Pacientes asc



-- Los apellidos y nombres de los médicos (sin repetir) que hayan demorado en alguno de sus turnos menos de la duración promedio de turnos.

-- Usando subconsultas
select distinct CONCAT(M.NOMBRE,' ',M.APELLIDO) as Medicos
from MEDICOS as M
where (
	select AVG(T.DURACION) from TURNOS as T 
) > any (
	select distinct T.DURACION from TURNOS as T 
	where T.IDMEDICO = M.IDMEDICO
)
order by Medicos asc


-- Sin subconsultas: MAL, calcula el promedio de duracion de turnos por medico y no del total de turnos
select distinct
	CONCAT(M.NOMBRE,' ',M.APELLIDO) as Medicos,
	AVG(T.DURACION) as DuracionPromedio,
	MIN(T.DURACION) as MinimoDuracion
from MEDICOS as M
	inner join TURNOS as T on T.IDMEDICO = M.IDMEDICO
group by CONCAT(M.NOMBRE,' ',M.APELLIDO) 
having MIN(T.DURACION) < AVG(T.DURACION)
order by Medicos asc



-- Por cada paciente, el apellido y nombre y la cantidad de turnos realizados en el primer semestre y 
-- la cantidad de turnos realizados en el segundo semestre. Indistintamente del año.

select 
	CONCAT(P.NOMBRE,' ',P.APELLIDO) as Paciente,
	(
		select count(T.IDPACIENTE) from TURNOS as T
		--where T.IDPACIENTE = P.IDPACIENTE and MONTH(T.FECHAHORA) between 1 and 6
		where T.IDPACIENTE = P.IDPACIENTE and MONTH(T.FECHAHORA) in (1,2,3,4,5,6)
	) as PS,
	(
		select count(T.IDPACIENTE) from TURNOS as T
		--where T.IDPACIENTE = P.IDPACIENTE and MONTH(T.FECHAHORA) between 7 and 12
		where T.IDPACIENTE = P.IDPACIENTE and MONTH(T.FECHAHORA) not in (1,2,3,4,5,6)
	) as SS
from PACIENTES as P
order by Paciente asc



-- Los pacientes que se hayan atendido más veces en el año 2000 que en el año 2001 y a su vez más veces en el año 2001 que en año 2002.

select CONCAT(P.NOMBRE,' ',P.APELLIDO) as Pacientes
from PACIENTES as P
where ((
	select count(T.IDPACIENTE) from TURNOS as T
	where T.IDPACIENTE = P.IDPACIENTE and YEAR(T.FECHAHORA) = 2000
) > (
	select count(T.IDPACIENTE) from TURNOS as T
	where T.IDPACIENTE = P.IDPACIENTE and YEAR(T.FECHAHORA) = 2001
) and (
	select count(T.IDPACIENTE) from TURNOS as T
	where T.IDPACIENTE = P.IDPACIENTE and YEAR(T.FECHAHORA) = 2001
) > (
	select count(T.IDPACIENTE) from TURNOS as T
	where T.IDPACIENTE = P.IDPACIENTE and YEAR(T.FECHAHORA) = 2002
)) 
order by Pacientes asc


