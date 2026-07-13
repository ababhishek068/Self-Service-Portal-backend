report 50106 "Update Dimensions."
{
    ApplicationArea = All;
    Caption = 'Update Dimensions';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ImprestHeader; "Imprest Header")

        {
            RequestFilterFields = "No.";
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(AccountNo; "Account No.") { }
            trigger OnPreDataItem()
            begin
                If NewDimension = '' then Error('New Dimension Must have a value');
                If oldDimension = '' then Error('Old Dimension Must have a value');
            end;

            trigger OnAfterGetRecord()
            begin
                impH.Reset();
                impH.SetRange("No.", ImprestHeader."No.");
                impH.SetRange("Shortcut Dimension 2 Code", OldDimension);
                if impH.Find('-') then begin
                    impH."Shortcut Dimension 2 Code" := NewDimension;
                    impH.Validate("Shortcut Dimension 2 Code");
                    impH.Validate("Global Dimension 1 Code");
                    impH.Modify();
                end;

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(OldDimension; OldDimension)
                    {
                        ApplicationArea = basic;
                        ToolTip = 'Specifies the value of the OldDimension field.';
                    }
                    field(NewDimension; NewDimension)
                    {
                        ApplicationArea = basic;
                        ToolTip = 'Specifies the value of the NewDimension field.';
                    }


                }
            }
        }
        actions
        {
            area(processing) { }

        }
    }
    var
        impH: Record "Imprest Header";
        OldDimension: Code[20];
        NewDimension: Code[20];
}