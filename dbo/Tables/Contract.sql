CREATE TABLE [dbo].[Contract] (
    [ID]           INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TeamID]       INT             NOT NULL,
    [PlayerID]     INT             NOT NULL,
    [Years]        TINYINT         NOT NULL,
    [Amount]       DECIMAL (18, 2) NOT NULL,
    [ContractFrom] DATE            NOT NULL,
    [ContractTo]   DATE            NOT NULL,
    CONSTRAINT [PK_Contract] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CK_Contract_Amount] CHECK ([Amount]>(0)),
    CONSTRAINT [CK_Contract_ContactFrom_To] CHECK ([ContractFrom]<[ContractTo]),
    CONSTRAINT [FK_Contract_Player] FOREIGN KEY ([PlayerID]) REFERENCES [dbo].[Player] ([ID]),
    CONSTRAINT [FK_Contract_Team] FOREIGN KEY ([TeamID]) REFERENCES [dbo].[Team] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Contract_PlayerID]
    ON [dbo].[Contract]([PlayerID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Contract_TeamID]
    ON [dbo].[Contract]([TeamID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Contract]
    ON [dbo].[Contract]([PlayerID] ASC, [TeamID] ASC, [ContractFrom] ASC);


GO

CREATE TRIGGER [dbo].[TRG_ContractOverlappingPrevent] 
   ON  [dbo].[Contract]
   AFTER INSERT, UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	if exists (
				select
					1 as ReturnValue
				from inserted i
					inner join dbo.Contract c on i.PlayerID = c.PlayerID
				where i.ID <> c.ID
					and SYSDATETIME() between c.ContractFrom and c.ContractTo
	)
	begin
		;throw 50000, 'There is another active contract for the player! Change is not permitted.', 1;
	end

	if exists (
				select
					1 as ReturnValue
				from inserted i
					inner join dbo.Contract c on i.PlayerID = c.PlayerID
				where i.ID <> c.ID
					and (
							i.ContractFrom between c.ContractFrom and c.ContractTo
							or
							i. ContractTo between c.ContractFrom and c.ContractTo
					)
	)
	begin
		; throw 50000, 'New contract is overlapping with existsing contract! Change is not permitted.', 1;
	end
END
