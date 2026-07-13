page 51274 "PC Strategic Activities"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Strategic Activities";
    Caption = 'Strategic Activities';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
                field("Key Result Area"; Rec."Key Result Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Key Result Area field.';
                }
                field("Strategic Objective"; Rec."Strategic Objective")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategic Objective field.';
                }
                field("Annual Plan"; Rec."Annual Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Annual Plan field.';
                }
                field(Impact; Rec.Impact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Impact field.';
                }
                field(Outcome; Rec.Outcome)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outcome field.';
                }
                field(Output; Rec.Output)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Output field.';
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Activity Code';
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Activity Description';
                    ToolTip = 'Specifies the value of the Activity Description field.';
                }
                field("Delivery Unit Type"; Rec."Delivery Unit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Unit Type field.';
                }
                field("Delivery Unit"; Rec."Delivery Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Unit field.';
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Performance Indicator field.';
                }
                field("Date From"; Rec."Date From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date From field.';
                }
                field("Date To"; Rec."Date To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date To field.';

                }
                field("Budget (In Millions)"; Rec."Budget (In Millions)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget (In Millions) field.';

                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source of Funds field.';

                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.';

                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.';

                }
                field("Global Dimension 3"; Rec."Global Dimension 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 3 field.';

                }
                field("Global Dimension 4"; Rec."Global Dimension 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 4 field.';

                }
                field("Global Dimension 5"; Rec."Global Dimension 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 5 field.';

                }
                field("Global Dimension 6"; Rec."Global Dimension 6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 6 field.';

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