



CREATE procedure [dbo].[InjurySave]
(
	@PlayerID int
	, @InjuryFrom date
)
as
begin
	
	declare @ErrorMessage nvarchar(4000);

	begin try

		insert into dbo.Injury (PlayerID, InjuryFrom)
		values (@PlayerID, @InjuryFrom)

	end try

	begin catch

		if @@TRANCOUNT > 0 and XACT_STATE() = 1
			rollback transaction;
			
		set @ErrorMessage = ERROR_MESSAGE();

		throw 50000, @ErrorMessage, 1;

	end catch
end
