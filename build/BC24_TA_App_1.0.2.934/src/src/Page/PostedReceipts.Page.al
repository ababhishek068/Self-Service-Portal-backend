Page 50903 "Posted Receipts"
{
    CardPageID = "Posted Receipt UP";
    Editable = false;
    PageType = List;
    SourceTable = "Receipts Header";
    SourceTableView = where("Posted Count" = filter(> 0));
    UsageCategory = History;
    ApplicationArea = lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(ReceivedFrom; Rec."Received From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(BankCode; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer No field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Customer Category"; Rec."Customer Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Category field.';
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Posted Count"; Rec."Posted Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted Count field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755010; Notes) { }
        }
    }

    actions
    {
        area(Reporting)
        {
            action("<Action1102760016>")
            {

                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    //  if Posted = false then Error('Post the receipt before printing.');

                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    Report.Run(50200, true, true, Rec);
                    Rec.Reset;
                end;
            }

        }
    }


}

