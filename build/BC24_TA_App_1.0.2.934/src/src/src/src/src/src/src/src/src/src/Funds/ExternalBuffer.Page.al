page 50466 "External Buffer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "External Buffer";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Item No"; Rec."Item No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';

                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Amount field.';

                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Amount field.';

                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discount Amount field.';

                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No field.';

                }
                field("Bank No"; Rec."Bank No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank No field.';

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field.';

                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';

                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No field.';

                }

                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }

                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Mode field.';

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';

                }
                field(Attendant; Rec.Attendant)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Attendant field.';

                }

            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process Transaction';
                Image = Process;
                ToolTip = 'Executes the Process Transaction action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}