Page 51351 "RFQ List Released"
{
    CardPageID = "RFQ Header";
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Purchase Quote Header";
    SourceTableView = where(Status = filter(Released));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field("Internal Requisition No."; Rec."Internal Requisition No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition No.';
                    ToolTip = 'Specifies the value of the Purchase Requisition No. field.';
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Description field.';
                }

                field("Expected Opening Date"; Rec."Expected Opening Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Opening Date field.';
                }
                field("Expected Closing Date"; Rec."Expected Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Closing Date field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }

    trigger OnOpenPage()
    var
    begin
    end;
}

