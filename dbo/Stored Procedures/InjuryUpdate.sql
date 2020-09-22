



CREATE procedure [dbo].[InjuryUpdate]
(
	@PlayerID int
	, @InjuryFrom date
	, @InjuryTo date
)
as
begin
	
	declare
			@ErrorMessage nvarchar(4000)
			, @rowcnt int;

	begin try

		update i
		set
			InjuryTo = @InjuryTo
		from dbo.Injury i
		where i.PlayerID = @PlayerID
			and i.InjuryFrom = @InjuryFrom;
		set @rowcnt = @@ROWCOUNT;

		if @rowcnt = 0
		begin
			;throw 50000, 'Record was not updated!', 1;
		end

	end try

	begin catch

		if @@TRANCOUNT > 0 and XACT_STATE() = 1
			rollback transaction;
			
		set @ErrorMessage = ERROR_MESSAGE();

		throw 50000, @ErrorMessage, 1;

	end catch
end
