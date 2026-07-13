Page 51258 "HR Appraisal Header Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Appraisal,Functions';
    SourceTable = "HR Appraisal Header - UP";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Appraisal No"; Rec."Appraisal No")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Appraisal No field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = all;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }

                FIELD(Designation; Rec.Designation)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field("Pay Grade / Job Group"; Rec."Pay Grade / Job Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Grade / Job Group field.';
                }

                field("Basic Salary"; Rec."Basic Salary")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Basic salary (PM) field.';
                }

                field("Acting Appoint"; Rec."Acting Appoint")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Acting Appointment / Special Duty field.';
                }

                field("Terms of service"; Rec."Terms of service")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Terms of service field.';
                }

                field("Appraisal Date"; Rec."Appraisal Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Appraisal Date field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }



                field("Evaluation Period Start Date"; Rec."Evaluation Period Start Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Evaluation Period Start Date field.';
                }
                field("Evaluation Period End Date"; Rec."Evaluation Period End Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Evaluation Period End Date field.';
                }

                field("Date of First Appointment"; Rec."Date of First Appointment")
                {
                    ApplicationArea = all;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date of First Appointment field.';
                }

                field("Last Date of Promotion"; Rec."Last Date of Promotion")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Date of Promotion field.';
                }
                field("Supervisor No."; Rec."Supervisor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Supervisor No. field.';
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Supervisor Name field.';
                }

                field("Supervisor User ID."; Rec."Supervisor User ID.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Supervisor User ID. field.';
                }
                field("Appraisal Stage"; Rec."Appraisal Stage")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Appraisal Stage field.';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Sent; Rec.Sent)
                {
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sent field.';
                }
            }
            part(Q1; "Appraisal Evaluation Lines")
            {
                Caption = 'Q1 Evaluation';
                SubPageLink = "Appraisal Code" = field("Appraisal No"), "Time Frame" = filter(Q1);
                Visible = AppFromWorkPlan;
            }
            part(Q2; "Appraisal Evaluation Lines")
            {
                Caption = 'Mid Year Evaluation';
                SubPageLink = "Appraisal Code" = field("Appraisal No"), "Time Frame" = filter(Q2);
                Visible = AppFromWorkPlan;
            }
            part(Q3; "Appraisal Evaluation Lines")
            {
                Caption = 'Q3 Evaluation';
                SubPageLink = "Appraisal Code" = field("Appraisal No"), "Time Frame" = filter(Q3);
                Visible = AppFromWorkPlan;
            }
            part(Q4; "Appraisal Evaluation Lines")
            {
                Caption = 'End Year Evaluation';
                SubPageLink = "Appraisal Code" = field("Appraisal No"), "Time Frame" = filter(Q4);
                Visible = AppFromWorkPlan;
            }
            part(Control1000000024; "HR Appraisal Lines - TD")
            {
                Caption = 'Staff Training and Development Plan';
                SubPageLink = "Appraisal No." = field("Appraisal No");
                Visible = AppFromWorkPlan;
            }
            part(Control1000000020; "HR Appraisal Lines - CS")
            {
                Caption = 'Section 2: Departmental Objectives';
                //Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period");
                SubPageLink = "Appraisal No." = field("Appraisal No");
                Visible = AppFromDefault;
            }
            part(Control1000000022; "HR Appraisal Lines - PT")
            {
                Caption = 'Section 3 - Performance Targets';
                SubPageLink = "Appraisal No." = field("Appraisal No");
                Visible = AppFromDefault;
            }
            part(Control1000000026; "HR Appraisal Lines - TD")
            {
                Caption = 'Section 4 - Staff Training and Development Plan';
                SubPageLink = "Appraisal No." = field("Appraisal No");
                Visible = AppFromDefault;
            }
            part(Control1000000023; "HR Appraisal Lines - VC")
            {
                Caption = 'Section 5a -Values and Core Competencies ';
                SubPageLink = "Appraisal No." = field("Appraisal No");
                Visible = AppFromDefault;
            }
            part(Control11; "HR Appraisal Lines - VC")
            {
                Caption = 'Section 5b - Managerial and Supervisory Competence ';
                SubPageLink = "Appraisal No." = field("Appraisal No");
                SubPageView = where(Category = const("Managerial and Supervisory Competence"));
                Visible = AppFromDefault;
            }
            group(Comments)
            {
                Caption = 'General Commenst';
                field("Comments Appraisee"; Rec."Comments Appraisee")
                {
                    Caption = 'Appraisee Comments';
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Appraisee Comments field.';
                }
                field("Comments Appraiser"; Rec."Comments Appraiser")
                {
                    Caption = 'Supervisor Comments';
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Supervisor Comments field.';
                }

            }
            // part(Control1000000020; "HR Appraisal Lines - CS")
            // {
            //     Caption = 'Customer/Stakeholder satisfaction(20%)';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");

            // }

            // part(Control100000029; "HR Appraisal Lines - FIN")
            // {
            //     Caption = 'Financial (12%)';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");

            // }

            // part(Control10000002339; "HR Appraisal Lines - IP")
            // {
            //     Caption = 'Internal processes(50%)';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");

            // }

            // part(Control100000023389; "HR Appraisal Lines - OC")
            // {
            //     Caption = 'Organisational capacity(18%)';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");

            // }
            // part(Control1000000022; "HR Appraisal Lines - PT")
            // {
            //     Caption = 'Section 3 - Performance Targets';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");
            //     Visible = AppFromDefault;
            // }

            // part(Control1000000023; "HR Appraisal Lines - VC")
            // {
            //     Caption = 'Section 5a -Values and Core Competencies ';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");
            //     Visible = AppFromDefault;
            // }
            // part(Control11; "HR Appraisal Lines - VC")
            // {
            //     Caption = 'Section 5b - Managerial and Supervisory Competence ';
            //     SubPageLink = "Appraisal No." = field("Appraisal No");
            //     SubPageView = where(Category = const("Managerial and Supervisory Competence"));
            //     Visible = AppFromDefault;
            // }
        }
        area(factboxes) { }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup8)
            {
                action("Send to Supervisor")
                {
                    ApplicationArea = all;
                    Caption = 'Send to Supervisor';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send to Supervisor action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Appraisee);


                        if Confirm('Do you wish to send this appraisal form to supervisor?', false) = false then exit;

                        Rec.Status := Rec.Status::Supervisor;
                        Rec.Modify;

                        Message('Appraisal form sent to supervisor');
                    end;
                }
                action("Return to Appraisee")
                {
                    ApplicationArea = all;
                    Caption = 'Return to Appraisee';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Return to Appraisee action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Supervisor);

                        if Confirm('Do you wish to return this appraisal form to appraise?', false) = false then exit;

                        Rec.Status := Rec.Status::Appraisee;
                        Rec.Modify;

                        Message('Appraisal form sent to Appraisee');
                    end;
                }
                action(LoadDeptObj)
                {
                    ApplicationArea = all;
                    Caption = 'Load Departmental Objectives';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Load Departmental Objectives action.';

                    trigger OnAction()
                    begin
                        if Confirm('Do you wish to load Departmental Objectives for [ %1 ] department?', false, Rec."Department Name") = false then Error('Process aborted');

                        //Clear Existing Lines
                        HRApprLinesDO.Reset();
                        HRApprLinesDO.SetRange("Appraisal No.", Rec."Appraisal No");
                        if not HRApprLinesDO.IsEmpty() then HRApprLinesDO.DeleteAll();

                        //Initialize Counter
                        Clear(CountObjectives);

                        HRAppDeptObjSetup.Reset();
                        HRAppDeptObjSetup.SetRange("Department Code", Rec."Department Code");
                        HRAppDeptObjSetup.SetRange(HRAppDeptObjSetup."Appraisal Period","Appraisal Period");
                        
                        if HRAppDeptObjSetup.FindSet(false, false) then begin
                            CountObjectives := HRAppDeptObjSetup.Count();

                            repeat
                                HRApprLinesDO.Init();

                                HRApprLinesDO."Appraisal No." := Rec."Appraisal No";
                                HRApprLinesDO."Objective Code" := HRAppDeptObjSetup."Objective Code";
                                HRApprLinesDO."Objective Description" := HRAppDeptObjSetup."Objective Description";
                                HRApprLinesDO."Department Code" := HRAppDeptObjSetup."Department Code";
                                //HRApprLinesDO."Perspective Type":=HRAppDeptObjSetup.perse
                                HRApprLinesDO."Perspective Code" := HRAppDeptObjSetup."Perspective Type";
                                HRApprLinesDO."Perspective Description" := HRAppDeptObjSetup."Perspective Description";

                                HRApprLinesDO.Insert();
                            until HRAppDeptObjSetup.Next() = 0;
                            Message('%1 Departmental objectives have been imported successfully', CountObjectives);
                        end else begin
                            Error('Please setup departmental objectives for the [ %1 ] department', Rec."Department Code");
                        end;
                    end;
                }
                action(LoadValuesCompetence)
                {
                    ApplicationArea = all;
                    Image = Loaner;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the LoadValuesCompetence action.';

                    trigger OnAction()
                    begin
                        if Confirm('Do you wish to load values and managerial competencies?', false) = false then Error('Process aborted');

                        //Clear Existing Lines
                        HRAppLinesValues.Reset();
                        HRAppLinesValues.SetRange("Appraisal No.", Rec."Appraisal No");
                        if not HRAppLinesValues.IsEmpty() then HRAppLinesValues.DeleteAll();

                        //Initialize Counter
                        Clear(CountObjectives);

                        HRAppValuesSetup.Reset();
                        if HRAppValuesSetup.FindSet(false, false) then begin
                            CountObjectives := HRAppValuesSetup.Count();

                            repeat
                                HRAppLinesValues.Init();

                                HRAppLinesValues."Appraisal No." := Rec."Appraisal No";
                                HRAppLinesValues.Code := HRAppValuesSetup.Code;
                                HRAppLinesValues.Category := HRAppValuesSetup.Category;
                                HRAppLinesValues.Description := HRAppValuesSetup.Description;

                                HRAppLinesValues.Insert();
                            until HRAppDeptObjSetup.Next() = 0;
                            Message('%1 staff values and managerial competencies have been imported successfully', CountObjectives);
                        end else begin
                            Error('Please setup staff values and managerial competencies');
                        end;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UnUsedDocs: Code[10];
        HRAppHeader: Record "HR Appraisal Header - UP";
        ERR_EXISTING_DOCS_EXIST: label 'There are still some Open Document on your account which have not been used. Please List & Select the pending document to use.  \\%1';
    begin
        UnUsedDocs := '';

        HRAppHeader.Reset;
        HRAppHeader.SetRange(HRAppHeader."Supervisor User ID.", UserId);
        HRAppHeader.SetRange(HRAppHeader.Status, HRAppHeader.Status::Appraisee);
        if HRAppHeader.Find('-') then begin
            repeat
                UnUsedDocs := UnUsedDocs + HRAppHeader."Appraisal No" + ' ';
            until HRAppHeader.Next = 0;


            if HRAppHeader.Count > 0 then begin
                Error(ERR_EXISTING_DOCS_EXIST, UnUsedDocs);
            end;
        end;
    end;

    trigger OnOpenPage()
    var
        HRSetup: Record "HR Setup";
    begin
        AppFromDefault := false;
        AppFromWorkPlan := false;
        if HRSetup.GET() then begin
            if HRSetup."Appraisal Form" = HRSetup."Appraisal Form"::"From Workplan" then
                AppFromWorkPlan := true
            else
                AppFromDefault := true;
        end;
    end;

    var
        HRAppDeptObjSetup: Record "HR Appraisal Dept. Obj. Setup";
        HRAppValuesSetup: Record "HR Appraisal Val and Compt-UP";
        //HRAppValuesSetup: Record "HR Appraisal Lines - Values-UP";
        //HR Appraisal Val and Compt-UP
        HRApprLinesDO: Record "HR Appraisal Lines - DO";
        HRAppLinesValues: Record "HR Appraisal Lines - Values";
        CountObjectives: Integer;
        AppFromDefault: Boolean;
        AppFromWorkPlan: Boolean;
}

