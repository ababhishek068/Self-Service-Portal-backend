Page 51096 "HR Appraisal Header Card360"
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
                Caption = 'Section 1: Personal Particulars';
                field("Appraisal No"; Rec."Appraisal No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Appraisal No field.';
                }
                field("Appraisal Date"; Rec."Appraisal Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Date field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field("Evaluation Period Start Date"; Rec."Evaluation Period Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Evaluation Period Start Date field.';
                }
                field("Evaluation Period End Date"; Rec."Evaluation Period End Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Evaluation Period End Date field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Date of First Appointment"; Rec."Date of First Appointment")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date of First Appointment field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Supervisor User ID."; Rec."Supervisor User ID.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor User ID. field.';
                }
                field("Appraisal Stage"; Rec."Appraisal Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Stage field.';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(Control1000000020; "HR Appraisal Lines - cs")
            {
                Caption = 'Section 2: Customer/Stakeholder satisfaction(20%)';
                SubPageLink = "Appraisal No." = field("Appraisal No");
            }
            part(Control1000000022; "HR Appraisal Lines - PT")
            {
                Caption = 'Section 3 - Financial (12%)';
                SubPageLink = "Appraisal No." = field("Appraisal No");
            }
            part(Control1000000024; "HR Appraisal Lines - TD")
            {
                Caption = 'Section 4 - Internal processes(50%)';
                SubPageLink = "Appraisal No." = field("Appraisal No");
            }
            part(Control1000000023; "HR Appraisal Lines - VC")
            {
                Caption = 'Section 5- Organisational capacity(18%)';
                SubPageLink = "Appraisal No." = field("Appraisal No");
            }
            part(Control11; "HR Appraisal Lines - VC")
            {
                Caption = 'Section 6 - Managerial and Supervisory Competence ';
                SubPageLink = "Appraisal No." = field("Appraisal No");
                SubPageView = where(Category = const("Managerial and Supervisory Competence"));
            }
        }
        area(factboxes)
        {
            systempart(Control1000000012; Notes) { }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup8)
            {
                action("Send to Supervisor")
                {
                    ApplicationArea = Basic;
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
                    ApplicationArea = Basic;
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
                    ApplicationArea = Basic;
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
                    ApplicationArea = Basic;
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

    var
        HRAppDeptObjSetup: Record "HR Appraisal Dept. Obj. Setup";
        HRAppValuesSetup: Record "HR Appraisal Lines - Values-UP";
        HRApprLinesDO: Record "HR Appraisal Lines - DO";
        HRAppLinesValues: Record "HR Appraisal Lines - Values";
        CountObjectives: Integer;
}

