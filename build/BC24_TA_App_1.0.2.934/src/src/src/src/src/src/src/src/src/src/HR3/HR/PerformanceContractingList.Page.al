page 50662 "Performance Contracting List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Perfomance Contrating";
    CardPageId = "Performance Contracting Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Workplan No"; Rec."Workplan No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan No field.';
                }
                field("Workplan Activity Code"; Rec."Workplan Activity Code")
                {
                    Caption = 'WorkPlan PC No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WorkPlan PC No. field.';
                }
                field("Perfomance Indicator"; Rec."Perfomance Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Perfomance Indicator field.';
                }
                field("PC Year"; Rec."PC Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PC Year field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field("Current Year Target"; Rec."Current Year Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Year Target field.';
                }
                field("Wt%"; Rec."Wt%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Wt% field.';
                }
                field("Status of Prev. Year"; Rec."Status of Prev. Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status of Prev. Year field.';
                }
                field("Quarter Target"; Rec."Quarter Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quarter Target field.';
                }
                field("Quarter Actual"; Rec."Quarter Actual")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quarter Actual field.';
                }
                field("Quarter Variance"; Rec."Quarter Variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quarter Variance field.';
                }

                field("Cummulative Actual"; Rec."Cummulative Actual")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cummulative Actual field.';
                }
                field("Cummulative Variance"; Rec."Cummulative Variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cummulative Variance field.';
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
}