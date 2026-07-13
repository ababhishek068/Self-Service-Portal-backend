pageextension 50014 CustomerCard extends "Customer Card"

{
    layout
    {
        addafter("IC Partner Code")
        {
            //on pages use snippet for field  
            field("Customer Category"; Rec."Customer Category")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Customer Category field.';
            }
            // field(MK; Rec.MK)
            // {
            //     ApplicationArea = all;
            //     ToolTip = 'Specifies the value of the MK field.';
            // }
            // field("MK Option DT"; Rec."MK Option DT")
            // {
            //     ApplicationArea = all;
            //     ToolTip = 'Specifies the value of the MK Option DT field.';
            // }
            field("Cash Customer"; Rec."Cash Customer")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Cash Customer field.';
            }
        }
        addafter("VAT Registration No.")
        {
            field("TIN No"; "TIN No")
            {
                ToolTip = 'Specify the TIN No of customer/staff';
                ApplicationArea = all;
            }
        }
        addafter(Blocked)
        {
            field("Staff No."; Rec."Staff No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Staff No. field.';

            }
            field("Staff Claims"; Rec."Staff Claims")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Staff Claims field.';
            }
            field("Account Type"; Rec."Account Type")
            {
                ApplicationArea = all;
                Caption = 'Account Type';
                ToolTip = 'Specifies the value of the Account Type field.';
            }
            field("Employee Job Group"; Rec."Employee Job Group")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Employee Job Group';
                ToolTip = 'Specifies the value of the Employee Job Group field.';
            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = all;
                Caption = 'Customer Type';
                ToolTip = 'Specifies the value of the Customer Type field.';
            }

        }

    }
    actions
    {
        addafter("Report Statement")
        {
            action("CustomStatement")
            {
                ApplicationArea = Basic;
                Image = Print;
                Caption = 'Customer Statement';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Customer Statement action.';
                trigger OnAction()
                var
                    Cust: Record Customer;
                begin
                    Cust.reset;
                    Cust.setfilter("No.", Rec."No.");
                    if Cust.find('-') then begin
                        if Cust."Currency Code" <> '' then
                            report.run(70135058, true, true, Cust)
                        else
                            Report.Run(70135648, true, false, Cust);
                    end;
                end;
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create Customer");

    end;
}