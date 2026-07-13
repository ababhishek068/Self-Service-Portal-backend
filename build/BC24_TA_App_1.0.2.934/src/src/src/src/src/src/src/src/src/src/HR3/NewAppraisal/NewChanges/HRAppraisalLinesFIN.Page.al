Page 51254 "HR Appraisal Lines - FIN"
{
    Caption = 'Financial (12%)';

    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    ShowFilter = false;
    SourceTable = "HR Appraisal Lines - DO";
    SourceTableView = where("Perspective Code" = filter('FINANCIAL'));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Perspective Code"; Rec."Perspective Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Perspective Code field.';
                }
                field("Perspective Description"; Rec."Perspective Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Perspective Description field.';

                }

                field("Strategic objectives"; Rec."Strategic objectives")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Strategic objectives field.';
                }
                field("Strategic/Dept initiatives"; Rec."Strategic/Dept initiatives")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Strategic departmental initiatives field.';
                }

                field("Objective Description"; Rec."Objective Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Performance Measures field.';

                }
                //field("Performance measures"; "Performance measures") { ApplicationArea = ALL; }
                field(Target; Rec.Target)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Target field.';
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Weight % field.';
                }
                field(July; Rec.July)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the July field.';
                }
                field(August; Rec.August)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the August field.';
                }

                field(September; Rec.September)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the September field.';
                }
                field(October; Rec.October)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the October field.';
                }
                field(November; Rec.November)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the November field.';
                }
                field(December; Rec.December)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the December field.';
                }
                field(January; Rec.January)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the January field.';
                }
                field(February; Rec.February)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the February field.';
                }
                field(March; Rec.March)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the March field.';
                }
                field(April; Rec.April)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the April field.';
                }
                field(May; Rec.May)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the May field.';
                }
                field(June; Rec.June)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the June field.';
                }
                field("Total Actual"; Rec."Total Actual")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Total Actual field.';
                }
                field(Max; Rec.Max)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Max field.';
                }
                field(Noderated; Rec.Noderated)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Noderated field.';
                }

                field(SCORE; Rec.SCORE)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the SCORE % field.';
                }
                field(Weighted; Rec.Weighted)
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Weighted % field.';
                }
                field("performance tracking"; Rec."performance tracking")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Weighted % field.';
                }
                field("Admissible evidence"; Rec."Admissible evidence")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Specifies the value of the Admissible evidence field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PerformanceTargets)
            {
                ApplicationArea = Basic;
                Image = TaskList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the PerformanceTargets action.';

                trigger OnAction()
                begin
                    Message('Performance Targets here');
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Perspective Code" := 'FINANCIAL';
        Rec.Validate("Perspective Code");
    end;
}

