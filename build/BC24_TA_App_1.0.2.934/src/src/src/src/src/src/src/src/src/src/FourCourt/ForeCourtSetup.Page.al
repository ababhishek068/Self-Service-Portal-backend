page 51357 "ForeCourt setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fore Court Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Dipping Nos"; Rec."Dipping Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dipping Nos field.';

                }
                field("Pump Reading Nos"; Rec."Pump Reading Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pump Reading Nos field.';

                }
                field("Return to Stock Nos"; Rec."Return to Stock Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Return to Stock Nos field.';

                }
                field("Shift Allocation Nos"; Rec."Shift Allocation Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift Allocation Nos field.';

                }
                field("Maximum Reading Variance"; Rec."Maximum Reading Variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Reading Variance field.';

                }
                field("Item Journal Template"; Rec."Item Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Template field.';

                }
                field("Item Journal Batch"; Rec."Item Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Journal Batch field.';

                }
                field("ForeCourt Department"; Rec."ForeCourt Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ForeCourt Department field.';

                }

                field("Invoice Clearance Account"; Rec."Invoice Clearance Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Clearance Account field.';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        UserRec: record "User Setup";
    begin
        UserRec.get(Database.UserId);
        userrec.TestField("Approval Administrator", true);
    end;
}