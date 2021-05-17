
--1) - Listar por cada viaje: El ID, el fecha, la capacidad del camión que lo realiza y la cantidad de paquetes de hasta 50 kilos y la cantidad de paquetes que superen los 50 kilos que transportó dicho viaje. (20 puntos)

select 
    V.ID,
    V.fecha,
    C.capacidad,
    (
        select count(P.ID) from paquetes as P
        where P.IDViaje = V.id and P.peso <= 50
    ) as paquetes50kilos,
    (
        select count(P.ID) from paquetes as P
        where P.IDViaje = V.id and P.peso > 50
    ) as paquetesMayores
from viajes as V
    inner join camiones as C on C.Patente = V.Patente
order by V.ID asc



--2) - Listar la información de los camiones que hayan realizado viajes el año pasado y que hayan llevado al menos un paquete de más de 150 kilos. (20 puntos)

select distinct * from camiones as c
    inner join viajes as v on v.Patente = c.Patente
    inner join paquetes as p on p.IDViaje = v.id
where YEAR(v.fecha) = 2020 and p.peso > 150
group by c.Patente
having count(distinct c.Patente) > 1
order by c.Patente asc



--3) - Listar la información del viaje más largo. Incluir en el listado el ID, la fecha del viaje y los Kms. (10 puntos)

select top 1
    V.id,
    V.fecha,
    v.kms
from viajes as V
order by v.kms desc

-- o si no tambien, con una subconsulta. 
--En caso de que haya varios viajes con km maximo, muestra todos

select 
    V.id,
    V.fecha,
    v.kms
from viajes as V
where v.kms = (select max(v2.kms) from viajes as v2)



--4) - Listar los ID de los viajes que hayan llevado en el año 2019, en promedio, más de 40 kilos por encomienda. (20 puntos)

select 
    v.id as idViaje,
    AVG(P.peso) as PromedioEncomienda
from viajes as v
    inner join paquetes as P on P.IDViaje = V.id
where YEAR(v.fecha) = 2019
group by v.id
having AVG(P.peso) > 40
order by v.id asc

-- usando subconsultas

select distinct v.id as idViaje
from viajes as v
where YEAR(V.fecha) = 2019 and (
    select AVG(p.peso) from paquetes as p
    where p.idViaje = v.id
) > 40 

