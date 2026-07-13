page 50021 "HR Committee WorkPlan"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HR Commitee Workplan";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {


                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Indicator"; Rec."Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Indicator field.';

                }
                field("Sub Indicator"; Rec."Sub Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Indicator field.';

                }
                field("Budget Allocation"; Rec."Budget Allocation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget Allocation field.';

                }
                field("Key Performance Indicator"; Rec."Key Performance Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Key Performance Indicator field.';

                }
                field("Scheduled Quarter"; Rec."Scheduled Quarter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scheduled Quarter field.';

                }
                field("Quarterly"; Rec."Quarterly")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quarterly field.';

                }
                field("Cummulative"; Rec."Cummulative")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cummulative field.';
                }
                field("Completion Date"; Rec."Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Completion Date field.';
                }
                field("Status"; Rec."Status")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Score"; Rec."Score")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score field.';
                }
                field(Variance; Rec.Variance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Variance field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }


            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}