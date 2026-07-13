page 50487 "Performance Contracting Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Perfomance Contrating";

    layout
    {
        area(Content)
        {
            group(General)
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
                field("Wt%"; Rec."Wt%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Wt% field.';
                }
            }
            group(Annual)
            {
                Caption = 'Annual';
                field("Current Year Target"; Rec."Current Year Target")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Year Target field.';
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
                field("Status of Prev. Year"; Rec."Status of Prev. Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status of Prev. Year field.';
                }
            }
            group(Quartely)
            {
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