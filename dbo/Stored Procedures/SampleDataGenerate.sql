

CREATE procedure [dbo].[SampleDataGenerate]
as
begin

	declare @ErrorMessage nvarchar(4000);

	begin try

		begin transaction

		insert into dbo.Position (Name)
		select
			t.Name
		from (
				values
					('point guard')
					, ('shooting guard')
					, ('small forward')
					, ('power forward')
					, ('center')
			) t (Name)
			left join dbo.Position p on t.Name = p.Name
		where p.ID is null;

		insert into dbo.Season (Name, SeasonFrom, SeasonTo)
		select
			t.Name
			, t.SeasonFrom
			, t.SeasonTo
		from (
				values
					('Season 2018/2019', convert(date, '2018-10-01', 120), convert(date, '2019-09-30', 120))
					, ('Season 2019/2020', convert(date, '2019-10-01', 120), convert(date, '2020-09-30', 120))
					, ('Season 2020/2021', convert(date, '2020-10-01', 120), convert(date, '2021-09-30', 120))
			) t (Name, SeasonFrom, SeasonTo)
			left join dbo.Season s on t.Name = s.Name
		where s.ID is null;

		insert into dbo.League (Name, SalaryBudget)
		select
			t.Name
			, t.SalaryBudget
		from (
				values
					('NBA', 50000000)
					, ('HKL', 10000000)
			) t (Name, SalaryBudget)
			left join dbo.League l on t.Name = l.Name
		where l.ID is null;

		insert into dbo.SeasonLeague (SeasonID, LeagueID, NumOfPlayers)
		select
			s.ID as SeasonID
			, l.ID as LeagueID
			, (case
					when l.Name = 'NBA' then 15
					when l.Name = 'HKL' then 20
					else 15
			end)
		from dbo.Season s
			cross join dbo.League l
			left join dbo.SeasonLeague sl on s.ID = sl.SeasonID
					and l.ID = sl.LeagueID
		where sl.ID is null;

		insert into dbo.Team (Name, LeagueID)
		select
			t.Name
			, t.LeagueID
		from (
				values ('Los Angeles Lakers', (select l.ID from dbo.League l where l.Name = 'NBA'))
				, ('New York Knicks', (select l.ID from dbo.League l where l.Name = 'NBA'))
				, ('Boston Celtics', (select l.ID from dbo.League l where l.Name = 'NBA'))
				, ('Cibona', (select l.ID from dbo.League l where l.Name = 'HKL'))
				, ('Zadar', (select l.ID from dbo.League l where l.Name = 'HKL'))
				, ('Zagreb', (select l.ID from dbo.League l where l.Name = 'HKL'))
			) t (Name, LeagueID)
			left join dbo.Team tt on t.Name = tt.Name
					and t.LeagueID = tt.LeagueID
		where tt.ID is null;

		insert into dbo.Player (FirstName, LastName, TeamID)
		select
			t.FirstName
			, t.LastName
			, t.TeamID
		from (
				VALUES ('Enes', 'Kanter', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Jayson', 'Tatum', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Jaylen', 'Brown', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Javonte', 'Green', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Gordon', 'Hayward', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Grant', 'Williams', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Carsen', 'Edwards', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Daniel', 'Theis', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Semi', 'Ojeleye', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Romeo', 'Langford', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Robert', 'Williams III', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Tacko', 'Fall', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Vincent', 'Poirier', (select t.ID from dbo.Team t where t.Name = 'Boston Celtics'))
				, ('Markieff', 'Morris', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Talen', 'Horton-Tucker', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Kostas', 'Antetokounmpo', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Kyle', 'Kuzma', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('LeBron', 'James', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Kentavious', 'Caldwell-Pope', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Quinn', 'Cook', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Rajon', 'Rondo', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Danny', 'Green', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Dwight', 'Howard', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Anthony', 'Davis', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Avery', 'Bradley', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Alex', 'Caruso', (select t.ID from dbo.Team t where t.Name = 'Los Angeles Lakers'))
				, ('Bobby', 'Waiters', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Allonzo', 'Trier', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Ignas', 'Brazdeikis', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Frank', 'Ntilikina', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Dennis', 'Smith Jr.', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Damyean', 'Dotson', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Elfrid', 'Payton', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Reggie', 'Bullock', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('RJ', 'Barrett', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Taj', 'Gibson', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Julius', 'Randle', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
				, ('Kadeem', 'Allen', (select t.ID from dbo.Team t where t.Name = 'New York Knicks'))
			) t (FirstName, LastName, TeamID)
			left join dbo.Player p on t.FirstName = p.FirstName
					and t.LastName = p.LastName
					and t.TeamID = p.TeamID
		where p.ID is null;

		insert into dbo.PlayerPosition (PlayerID, PositionID)
		select
			t.PlayerID
			, t.PositionID
		from (
				select
					p.ID as PlayerID
					, pos.ID as PositionID
					, ROW_NUMBER() over (partition by p.ID order by newid() asc) as Rnm
				from dbo.Player p
					cross join dbo.Position pos
			) t
			left join dbo.PlayerPosition pp on t.PlayerID = pp.PlayerID
					and t.PositionID = pp.PositionID
		where t.Rnm <= dbo.fn_HexToInt (left(NEWID(), 4)) % 2 + 1
			and pp.PlayerID is null;

		insert into dbo.Injury (PlayerID, InjuryFrom, InjuryTo)
		select
			p.ID
			, dateadd (day, p.ID, s.SeasonFrom) as SeasonFrom
			, dateadd(month, 3, dateadd (day, p.ID, s.SeasonFrom)) as SeasonTo
		from (
			select
				distinct
				t.RandID
			from (
					select
						distinct
						(dbo.fn_HexToInt (left(NEWID(), 4)) % (select count(p.ID) from dbo.Player p)) + 1 as RandID
						, ROW_NUMBER() over (partition by p.TeamID order by p.ID) as Rnm
					from dbo.Player p
			) t
			where t.Rnm <= 2
		) t
			inner join dbo.Player p on t.RandID = p.ID
			inner join dbo.Team team on p.TeamID = team.ID
			inner join dbo.SeasonLeague sl on team.LeagueID = sl.LeagueID
			inner join dbo.Season s on sl.SeasonID = s.ID
					and SYSDATETIME() between s.SeasonFrom and s.SeasonTo
			left join dbo.Injury i on p.ID = i.PlayerID
					and dateadd (day, p.ID, s.SeasonFrom) = i.InjuryFrom
		where i.ID is null;

		insert into dbo.Contract (TeamID, PlayerID, Years, Amount, ContractFrom, ContractTo)
		select
			p.TeamID
			, p.ID as PlayerID
			, dbo.fn_HexToInt (left(newid(), 4)) % 5 + 1 as Years
			, (dbo.fn_HexToInt (left(newid(), 4)) % 5 + 1) * 1000000 as Amount
			, dateadd(day, -1 * p.ID, s.SeasonFrom) as ContractFrom
			, dateadd(year, dbo.fn_HexToInt (left(newid(), 4)) % 5 + 1, dateadd(day, -1 * p.ID, s.SeasonFrom)) as ContractTo
		from dbo.Player p
			inner join dbo.Team team on p.TeamID = team.ID
			inner join dbo.SeasonLeague sl on team.LeagueID = sl.LeagueID
			inner join dbo.Season s on sl.SeasonID = s.ID
					and SYSDATETIME() between s.SeasonFrom and s.SeasonTo
			left join dbo.Contract c on p.TeamID = c.TeamID
					and p.ID = c.PlayerID
					and c.ContractFrom = dateadd(day, -1 * p.ID, s.SeasonFrom)
		where c.ID is null;

		commit transaction

	end try

	begin catch
		if @@TRANCOUNT > 0 and XACT_STATE() = 1
			rollback tran;

		set @ErrorMessage = ERROR_MESSAGE();

		throw 50000, @ErrorMessage, 1;

	end catch
end
