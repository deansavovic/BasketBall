CREATE TABLE [dbo].[Season] (
    [ID]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]       NVARCHAR (100) NOT NULL,
    [SeasonFrom] DATE           NOT NULL,
    [SeasonTo]   DATE           NOT NULL,
    CONSTRAINT [PK_Season] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CK_Season_SeasonFrom_To] CHECK ([SeasonFrom]<[SeasonTo])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_Season]
    ON [dbo].[Season]([Name] ASC);

