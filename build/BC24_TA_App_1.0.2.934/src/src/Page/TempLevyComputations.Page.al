page 50007 "Temp Levy Computations"
{
    ApplicationArea = All;
    Caption = 'Temp Levy Computations';
    PageType = List;
    SourceTable = "Temp Levy Computations";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field("Line No."; Rec."Line No.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Line No. field.';
                // }
                field("CS. NO"; Rec."CS. NO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CS. NO field.';
                }
                field("DT-NAME"; Rec."DT-NAME")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DT-NAME field.';
                }
                field("TOTAL DEPOSITS"; Rec."TOTAL DEPOSITS")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TOTAL DEPOSITS field.';
                }
                field(PERCENTAGE; Rec.PERCENTAGE)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PERCENTAGE field.';
                }
                field("LEVY COMPUTATION"; Rec."LEVY COMPUTATION")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LEVY COMPUTATION field.';
                }


                field("LEVY CAPPED"; Rec."LEVY CAPPED")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LEVY CAPPED field.';
                }

            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(ImportLevy)
            {
                Image = Import;
                caption = 'Import Levy';
                ApplicationArea = basic;
                RunObject = xmlport "Import Levy";
                ToolTip = 'Executes the Import Levy action.';
            }
        }
    }
}
