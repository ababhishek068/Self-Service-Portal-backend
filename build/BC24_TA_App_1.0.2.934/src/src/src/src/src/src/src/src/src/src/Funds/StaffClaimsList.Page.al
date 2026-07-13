page 50472 "Staff Claims List"
{
    CardPageID = "Staff Claims";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Staff Claims Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    //SourceTableView = where(Status = filter(<> Posted));
    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(TotalNetAmount; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field(TotalNetAmountLCY; Rec."Total Net Amount LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount LCY field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
            }
        }
    }

    actions { }
    trigger OnOpenPage()

    begin
        // if UserTemp.get(Database.UserId) then
        //     if UserTemp."Source of Funds" <> '' then
        //         setfilter("Shortcut Dimension 3 Code", UserTemp."Source of Funds");
    end;
}

