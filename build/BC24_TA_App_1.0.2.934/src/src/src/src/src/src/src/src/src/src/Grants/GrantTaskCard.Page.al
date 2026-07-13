Page 50075 "Grant Task Card"
{
    Caption = 'Grant Activity Card';
    DataCaptionExpression = Rec.Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Job-Task";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(GrantTaskNo; Rec."Grant Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grant Task No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(GrantTaskType; Rec."Grant Task Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Task Type field.';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Totaling field.';
                }
                field(GrantPostingGroup; Rec."Grant Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Posting Group field.';
                }
                field(NewPage; Rec."New Page")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the New Page field.';
                }
                field(NoofBlankLines; Rec."No. of Blank Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. of Blank Lines field.';
                }
            }
            group(WIP)
            {
                Caption = 'WIP';
                field(WIPMethodUsed; Rec."WIP Method Used")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Method Used field.';
                }
                field(WIPPostingDate; Rec."WIP Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Posting Date field.';
                }
                field(WIPAccount; Rec."WIP Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Account field.';
                }
                field(WIPBalanceAccount; Rec."WIP Balance Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Balance Account field.';
                }
                field(WIPAmount; Rec."WIP Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Amount field.';
                }
                field(InvoicedSalesAmount; Rec."Invoiced Sales Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced Sales Amount field.';
                }
                field(InvoicedSalesAccount; Rec."Invoiced Sales Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced Sales Account field.';
                }
                field(InvoicedSalesBalAccount; Rec."Invoiced Sales Bal. Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoiced Sales Bal. Account field.';
                }
                field(WIPPostingDateFilter; Rec."WIP Posting Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Posting Date Filter field.';
                }
                field(WIPPlanningDateFilter; Rec."WIP Planning Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Planning Date Filter field.';
                }
                field(WIPScheduleTotalCost; Rec."WIP Schedule (Total Cost)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Schedule (Total Cost) field.';
                }
                field(WIPScheduleTotalPrice; Rec."WIP Schedule (Total Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Schedule (Total Price) field.';
                }
                field(WIPUsageTotalCost; Rec."WIP Usage (Total Cost)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Usage (Total Cost) field.';
                }
                field(WIPUsageTotalPrice; Rec."WIP Usage (Total Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Usage (Total Price) field.';
                }
                field(WIPContractTotalCost; Rec."WIP Contract (Total Cost)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Contract (Total Cost) field.';
                }
                field(WIPContractTotalPrice; Rec."WIP Contract (Total Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP Contract (Total Price) field.';
                }
                field(WIPInvoicedPrice; Rec."WIP (Invoiced Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP (Invoiced Price) field.';
                }
                field(WIPInvoicedCost; Rec."WIP (Invoiced Cost)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the WIP (Invoiced Cost) field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(GrantTask)
            {
                Caption = '&Grant Task';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Grant Task Dimensions";
                    RunPageLink = "Job No." = field("Grant No."),
                                  "Job Task No." = field("Grant Task No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
            }
        }
    }
}

