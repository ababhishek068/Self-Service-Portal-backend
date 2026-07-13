Page 50079 "Grant WIP Entries"
{
    Caption = 'Grant WIP Entries';
    DataCaptionFields = "Job No.";
    Editable = false;
    PageType = Card;
    SourceTable = "Job-WIP Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(WIPPostingDate; Rec."WIP Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Posting Date field.';
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field(GLAccountNo; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field(GLBalAccountNo; Rec."G/L Bal. Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Bal. Account No. field.';
                }
                field(WIPMethodUsed; Rec."WIP Method Used")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Method Used field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(WIPEntryAmount; Rec."WIP Entry Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Entry Amount field.';
                }
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Posting Group field.';
                }
                field(WIPScheduleTotalCost; Rec."WIP Schedule (Total Cost)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Schedule (Total Cost) field.';
                }
                field(WIPScheduleTotalPrice; Rec."WIP Schedule (Total Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Schedule (Total Price) field.';
                }
                field(WIPUsageTotalCost; Rec."WIP Usage (Total Cost)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Usage (Total Cost) field.';
                }
                field(WIPUsageTotalPrice; Rec."WIP Usage (Total Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Usage (Total Price) field.';
                }
                field(WIPContractTotalCost; Rec."WIP Contract (Total Cost)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Contract (Total Cost) field.';
                }
                field(WIPContractTotalPrice; Rec."WIP Contract (Total Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Contract (Total Price) field.';
                }
                field(WIPInvoicedPrice; Rec."WIP (Invoiced Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP (Invoiced Price) field.';
                }
                field(WIPInvoicedCost; Rec."WIP (Invoiced Cost)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP (Invoiced Cost) field.';
                }
                field(WIPPlanningDateFilter; Rec."WIP Planning Date Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Planning Date Filter field.';
                }
                field(WIPPostingDateFilter; Rec."WIP Posting Date Filter")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Posting Date Filter field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Ent&ry';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Ledger Entry Dimensions";
                    RunPageLink = "Entry No." = field("Entry No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
            }
        }
    }
}

