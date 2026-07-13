page 50216 "Proc. Plan Activities Card"
{
    // version W/P

    Caption = 'Procurement Plan Activities Card';
    PageType = Document;
    UsageCategory = Documents;
    ApplicationArea = All;
    SourceTable = "Workplan Activities";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = ActivitiesIndent;
                IndentationControls = "Activity Description";

                field("Activity Code"; Rec."Activity Code")
                {
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ToolTip = 'Specifies the value of the Activity Description field.';
                }

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }

                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                }

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Procurement Workplan Code"; Rec."Procurement Workplan Code")
                {
                    ToolTip = 'Specifies the value of the Procurement Workplan Code field.';
                }
                field("Converted to G/L Budget"; Rec."Converted to G/L Budget")
                {
                    ToolTip = 'Specifies the value of the Converted to G/L Budget field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ConvertToBudget)
            {
                Caption = 'Convert to Budget';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Convert to Budget action.';
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ActivitiesIndent := 0;
        WorkPlanCodeOnFormat;
    end;

    var
        [InDataSet]
        "WorkPlan CodeEmphasize": Boolean;
        [InDataSet]
        ActivitiesIndent: Integer;

    procedure SetSelection(var GLAcc: Record "Workplan");
    begin
    end;

    procedure GetSelectionFilter(): Code[80];
    begin
    end;

    local procedure WorkPlanCodeOnFormat();
    begin
        "WorkPlan CodeEmphasize" := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

}

