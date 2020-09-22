
create procedure [dbo].[TwoTeamTradeSave]
(
	@PlayersTeam1JSON nvarchar(max)
	, @PlayersTeam2JSON nvarchar(max)
	, @Team1ID int
	, @Team2ID int
)
as
begin

	declare
			@ErrorMessage nvarchar(4000)
			, @rowcnt1 int
			, @rowcnt2 int;

	begin try

		select
			t.PlayerID
			, t.Amount
			, t.ContractFrom
			, t.ContractTo
			, t.Years
		into #PlayersTeam1
		from OPENJSON (@PlayersTeam1JSON)
			with (
				PlayerID int 'strict $.PlayerID'
				, Amount decimal(18, 2) '$.Amount'
				, ContractFrom date '$.ContractFrom'
				, ContractTo date '$.ContractTo'
				, Years tinyint '$.Years'
			) t
		set @rowcnt1 = @@ROWCOUNT;

		select
			t.PlayerID
			, t.Amount
			, t.ContractFrom
			, t.ContractTo
			, t.Years
		into #PlayersTeam2
		from OPENJSON (@PlayersTeam2JSON)
			with (
				PlayerID int 'strict $.PlayerID'
				, Amount decimal(18, 2) '$.Amount'
				, ContractFrom date '$.ContractFrom'
				, ContractTo date '$.ContractTo'
				, Years tinyint '$.Years'
			) t
		set @rowcnt2 = @@ROWCOUNT;

		select
			1 as ReturnValue
		into #tmp1
		from #PlayersTeam1 pt
			inner join dbo.Player p on pt.PlayerID = p.ID
		where p.TeamID = @Team1ID;
		if @rowcnt1 <> @@ROWCOUNT
		begin
			;throw 50000, 'Invalid data in JSON for players of team1!', 1;
		end

		select
			1 as ReturnValue
		into #tmp2
		from #PlayersTeam2 pt
			inner join dbo.Player p on pt.PlayerID = p.ID
		where p.TeamID = @Team2ID;
		if @rowcnt2 <> @@ROWCOUNT
		begin
			;throw 50000, 'Invalid data in JSON for players of team2!', 1;
		end

		begin transaction;

		insert into dbo.Contract (PlayerID, TeamID, Years, ContractFrom, ContractTo, Amount)
		select
			pt.PlayerID
			, @Team2ID as TeamID
			, pt.Years
			, pt.ContractFrom
			, pt.ContractTo
			, pt.Amount
		from #PlayersTeam1 pt
		union all
		select
			pt.PlayerID
			, @Team1ID as TeamID
			, pt.Years
			, pt.ContractFrom
			, pt.ContractTo
			, pt.Amount
		from #PlayersTeam1 pt

		update p
		set
			TeamID = @Team2ID
		from #PlayersTeam1 pt
			inner join dbo.Player p on pt.PlayerID = p.ID

		update p
		set
			TeamID = @Team1ID
		from #PlayersTeam2 pt
			inner join dbo.Player p on pt.PlayerID = p.ID

		commit transaction

	end try

	begin catch
		if @@TRANCOUNT > 0 and XACT_STATE() = 1
			rollback transaction;

		set @ErrorMessage = ERROR_MESSAGE();

		throw 50000, @ErrorMessage, 1;

	end catch

end
