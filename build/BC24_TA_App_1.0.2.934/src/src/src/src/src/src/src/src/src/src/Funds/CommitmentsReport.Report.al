Report 50287 "Commitments Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CommitmentsReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Committment; Committment)
        {
            column(ReportForNavId_1; 1) { }
            column(LineNo_Committment; Committment."Line No.") { }
            column(Date_Committment; Committment.Date) { }
            column(PostingDate_Committment; Committment."Posting Date") { }
            column(DocumentType_Committment; Committment."Document Type") { }
            column(DocumentNo_Committment; Committment."Document No.") { }
            column(Amount_Committment; Committment.Amount) { }
            column(Committed_Committment; Committment.Committed) { }
            column(CommittedBy_Committment; Committment."Committed By") { }
            column(CommittedDate_Committment; Committment."Committed Date") { }
            column(ShortcutDimension1Code_Committment; Committment."Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code_Committment; Committment."Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code_Committment; Committment."Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code_Committment; Committment."Shortcut Dimension 4 Code") { }
            column(GLAccountNo_Committment; Committment."G/L Account No.") { }
            column(Budget_Committment; Committment.Budget) { }
            column(MonthBudget_Committment; Committment."Month Budget") { }
            column(MonthActual_Committment; Committment."Month Actual") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

