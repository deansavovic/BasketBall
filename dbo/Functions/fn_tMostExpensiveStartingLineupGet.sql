
CREATE function [dbo].[fn_tMostExpensiveStartingLineupGet]
(
	@TeamID int
)
returns table
as
return
select
	p.Name as Position
	, max(case
			when p.Name = 'point guard' then ppg.FirstName + ' ' + ppg.LastName
			when p.Name = 'shooting guard' then psg.FirstName + ' ' + psg.LastName
			when p.Name = 'small forward' then psf.FirstName + ' ' + psf.LastName
			when p.Name = 'power forward' then ppf.FirstName + ' ' + ppf.LastName
			when p.Name = 'center' then pct.FirstName + ' ' + pct.LastName
			else null
	end) as PlayerName
from dbo.Position p
	outer apply (
			select
				top (1)
				pg_pp.PlayerID
			from dbo.Contract pg_c
				inner join dbo.PlayerPosition pg_pp on pg_c.PlayerID = pg_pp.PlayerID
				inner join dbo.Position pg_p on pg_pp.PositionID = pg_p.ID
				left join dbo.Injury pg_i on pg_c.PlayerID = pg_i.PlayerID
						and SYSDATETIME() between pg_i.InjuryFrom and pg_i.InjuryTo
			where SYSDATETIME() between pg_c.ContractFrom and pg_c.ContractTo
				and pg_c.TeamID = @TeamID
				and pg_p.Name = 'point guard'
				and pg_i.ID is null
			order by pg_c.Amount desc
					, pg_p.ID desc
	) pg
	left join dbo.Player ppg on pg.PlayerID = ppg.ID
	outer apply (
			select
				top (1)
				sg_pp.PlayerID
			from dbo.Contract sg_c
				inner join dbo.PlayerPosition sg_pp on sg_c.PlayerID = sg_pp.PlayerID
				inner join dbo.Position sg_p on sg_pp.PositionID = sg_p.ID
				left join dbo.Injury sg_i on sg_c.PlayerID = sg_i.PlayerID
						and SYSDATETIME() between sg_i.InjuryFrom and sg_i.InjuryTo
			where SYSDATETIME() between sg_c.ContractFrom and sg_c.ContractTo
				and sg_c.TeamID = @TeamID
				and sg_p.Name = 'shooting guard'
				and sg_pp.PlayerID <> isnull(pg.PlayerID, -99)
				and sg_i.ID is null
			order by sg_c.Amount desc
					, sg_p.ID desc
	) sg
	left join dbo.Player psg on sg.PlayerID = psg.ID
	outer apply (
			select
				top (1)
				sf_pp.PlayerID
			from dbo.Contract sf_c
				inner join dbo.PlayerPosition sf_pp on sf_c.PlayerID = sf_pp.PlayerID
				inner join dbo.Position sf_p on sf_pp.PositionID = sf_p.ID
				left join dbo.Injury sf_i on sf_c.PlayerID = sf_i.PlayerID
						and SYSDATETIME() between sf_i.InjuryFrom and sf_i.InjuryTo
			where SYSDATETIME() between sf_c.ContractFrom and sf_c.ContractTo
				and sf_c.TeamID = @TeamID
				and sf_p.Name = 'small forward'
				and sf_pp.PlayerID not in (isnull(pg.PlayerID, -99), isnull(sg.PlayerID, -99))
				and sf_i.ID is null
			order by sf_c.Amount desc
					, sf_p.ID desc
	) sf
	left join dbo.Player psf on sf.PlayerID = psf.ID
	outer apply (
			select
				top (1)
				pf_pp.PlayerID
			from dbo.Contract pf_c
				inner join dbo.PlayerPosition pf_pp on pf_c.PlayerID = pf_pp.PlayerID
				inner join dbo.Position pf_p on pf_pp.PositionID = pf_p.ID
				left join dbo.Injury pf_i on pf_c.PlayerID = pf_i.PlayerID
						and SYSDATETIME() between pf_i.InjuryFrom and pf_i.InjuryTo
			where SYSDATETIME() between pf_c.ContractFrom and pf_c.ContractTo
				and pf_c.TeamID = @TeamID
				and pf_p.Name = 'power forward'
				and pf_pp.PlayerID not in (isnull(pg.PlayerID, -99), isnull(sg.PlayerID, -99), isnull(sf.PlayerID, -99))
				and pf_i.ID is null
			order by pf_c.Amount desc
					, pf_p.ID desc
	) pf
	left join dbo.Player ppf on pf.PlayerID = ppf.ID
	outer apply (
			select
				top (1)
				ct_pp.PlayerID
			from dbo.Contract ct_c
				inner join dbo.PlayerPosition ct_pp on ct_c.PlayerID = ct_pp.PlayerID
				inner join dbo.Position ct_p on ct_pp.PositionID = ct_p.ID
				left join dbo.Injury ct_i on ct_c.PlayerID = ct_i.PlayerID
						and SYSDATETIME() between ct_i.InjuryFrom and ct_i.InjuryTo
			where SYSDATETIME() between ct_c.ContractFrom and ct_c.ContractTo
				and ct_c.TeamID = @TeamID
				and ct_p.Name = 'center'
				and ct_pp.PlayerID not in (isnull(pg.PlayerID, -99), isnull(sg.PlayerID, -99), isnull(sf.PlayerID, -99), isnull(pf.PlayerID, -99))
				and ct_i.ID is null
			order by ct_c.Amount desc
					, ct_p.ID desc
	) ct
	left join dbo.Player pct on ct.PlayerID = pct.ID
group by p.Name;
