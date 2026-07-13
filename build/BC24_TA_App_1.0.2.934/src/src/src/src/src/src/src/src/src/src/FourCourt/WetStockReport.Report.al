report 50034 "WetStock Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; Location)
        {
            column(Code; code) { }
            column(Name; Name) { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Location Code" = field(Code);
                column(Posting_Date; "Posting Date") { }
                column(Entry_Type; "Entry Type") { }
                column(Document_No_; "Document No.") { }
                column(Quantity; Quantity) { }
                trigger OnAfterGetRecord()
                begin

                end;
            }
            trigger OnAfterGetRecord()
            Var
                ItmLed: Record "Item Ledger Entry";
            begin
                ItmLed.Reset();
                ItmLed.SetRange("Location Code", Code);
                ItmLed.SetRange("Posting Date", startDate, endDate);
                ItmLed.SetFilter("Entry Type", 'Sale');
                if ItmLed.find('-') then
                    Sales := ItmLed.Quantity + Sales;
                //until ItmLed.next = 0;

                ItmLed.Reset();
                ItmLed.SetRange("Location Code", Code);
                ItmLed.SetRange("Posting Date", startDate, endDate);
                ItmLed.SetFilter("Entry Type", 'Transfer');
                if ItmLed.find('-') then
                    //repeat
                        Transfers := ItmLed.Quantity + Transfers;
                //until ItmLed.next = 0;


            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }

    //rendering
    //{
    //   layout(LayoutName)
    //   {
    //       Type = RDLC;
    //      LayoutFile = 'mylayout.rdl';
    //  }
    //}

    var
        Sales: Decimal;
        Transfers: Decimal;
        startDate: date;
        endDate: Date;
    //period: array of [];
}