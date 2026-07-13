report 50349 "Item Statement"
{
    ApplicationArea = All;
    Caption = 'Item Statement';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            column(ItemNo; "Item No.") { }
            column(Description; Description) { }
            column(DocumentDate; "Document Date") { }
            column(DocumentNo; "Document No.") { }
            column(EntryType; "Entry Type") { }

            column(strDesc; strDesc) { }
            column(CostAmountActual; "Cost Amount (Actual)") { }
            column(Quantity; Quantity) { }
            column(PostingDate; "Posting Date") { }

            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(CompAdd1; CompInf.Address) { }
            column(CompAdd2; CompInf."Address 2") { }

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                strDesc := '';
                recItem.reset;
                recItem.SetRange(recItem."No.", "Item No.");
                if recItem.Find('-') then begin
                    strDesc := recItem.Description;

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
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
    var
        CompInf: Record "Company Information";
        recItem: Record Item;

        strDesc: Text;

}
