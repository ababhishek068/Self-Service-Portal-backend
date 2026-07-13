namespace PTL.HRMIS;
using System.IO;

page 51522 "Performance KPI Setup"
{
    ApplicationArea = All;
    Caption = 'Performance KPI Setup';
    PageType = List;
    SourceTable = "Performance KPI Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Global Dimendion 1 Code"; Rec."Global Dimendion 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimendion 1 Code field.';
                }
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                }
                field("KPI Description"; Rec."KPI Description")
                {
                    ToolTip = 'Specifies the value of the KPI Description field.', Comment = '%';
                }
                field("Overall Target"; Rec."Overall Target")
                {
                    ToolTip = 'Specifies the value of the Overall Target field.', Comment = '%';
                }
                field("Weighted Target"; Rec."Weighted Target")
                {
                    ToolTip = 'Specifies the value of the Weighted Target field.';

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Generate)
            {
                ApplicationArea = All;
                Caption = 'Export/Import Staff KPI';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate Staff KPI';
                RunObject = page "Config. Packages";
            }
        }
    }
}
