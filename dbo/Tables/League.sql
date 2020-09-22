CREATE TABLE [dbo].[League] (
    [ID]           INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]         NVARCHAR (100)  NOT NULL,
    [SalaryBudget] DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_League] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CK_League_SalaryBudget] CHECK ([SalaryBudget]>(0))
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_League]
    ON [dbo].[League]([Name] ASC);

