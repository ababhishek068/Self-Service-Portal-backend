Page 51160 "HR Appraisal Header List - All"
{
    CardPageID = "HR Appraisal Header Card - All";
    DeleteAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "HR Appraisal Header - UP";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Appraisal No"; Rec."Appraisal No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Appraisal No field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Date of First Appointment"; Rec."Date of First Appointment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of First Appointment field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field("Appraisal Stage"; Rec."Appraisal Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Stage field.';
                }
                field("Appraisal Date"; Rec."Appraisal Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Date field.';
                }
                field("Evaluation Period Start Date"; Rec."Evaluation Period Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Evaluation Period Start Date field.';
                }
                field("Evaluation Period End Date"; Rec."Evaluation Period End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Evaluation Period End Date field.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Send to Supervisor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send to Supervisor';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = true;
                    ToolTip = 'Executes the Send to Supervisor action.';

                    trigger OnAction()
                    begin
                        if Confirm('Send to supervisor?', false) = false then exit;


                        //Get Supervisor

                        HREmp.SetRange(HREmp."User ID", UserId);
                        if HREmp.Find('-') then begin



                            //Supervisor ID
                            HREmp2.Reset;
                            HREmp2.SetRange(HREmp2."No.", HREmp."Manager No.");
                            if HREmp2.Find('-') then begin
                                Rec."Supervisor User ID." := HREmp2."User ID";

                                Rec.Status := Rec.Status::Supervisor;
                            end else begin
                                Error('Staff No [ %1 ] not found in HR Employees table', HREmp2."Manager No.");
                            end;
                            Rec.Modify;
                            Message('Appraisal sent to supervisor [ %1 ]', Rec."Supervisor User ID.");


                            //Supervisor ID
                        end else begin
                            Error('User ID [ %1 ] not found in HR Employees table', UserId);
                        end;
                    end;
                }
                action(ReturnAppraisee)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return to Appraisee';
                    Enabled = true;
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ToolTip = 'Executes the Return to Appraisee action.';

                    trigger OnAction()
                    begin
                        //TESTFIELD("Appraisal Stage","Appraisal Stage"::"Target Approval");
                        if Confirm('Return to appraisee?', false) = false then exit;

                        //"Appraisal Stage":="Appraisal Stage"::"Target Setting";
                        Rec.Status := Rec.Status::Appraisee;
                        Rec.Modify;

                        Message('Appraisal returned to appraisee');
                    end;
                }
                action(ReturnSupervisor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return to Supervisor';
                    Image = Return;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = true;
                    ToolTip = 'Executes the Return to Supervisor action.';

                    trigger OnAction()
                    begin
                        //TESTFIELD("Appraisal Stage","Appraisal Stage"::"End Year Evalauation");

                        if Confirm('Return to supervisor?', false) = false then exit;

                        //"Appraisal Stage":="Appraisal Stage"::"Target Approval";
                        Rec.Status := Rec.Status::Supervisor;
                        Rec.Modify;
                        Message('Appraisal returned to supervisor');
                    end;
                }
                action("Close Appraisal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Executes the Close Appraisal action.';

                    trigger OnAction()
                    begin
                        Rec.TestField("Employee No.");

                        if Confirm('Approve targets?', false) = false then exit;
                        Rec.TestField("Employee No.");

                        if Confirm('Approve targets?', false) = false then exit;
                        Rec.Status := Rec.Status::Closed;
                        Rec.Status := Rec.Status::Closed;
                        //"Appraisal Stage":="Appraisal Stage"::"End Year Evalauation";

                        Message('AppraisalClosed Successfully')
                    end;
                }
                action("Calculate Scores")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Scores';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;
                    ToolTip = 'Executes the Calculate Scores action.';

                    trigger OnAction()
                    begin
                        //fn_CalculateScore;

                        //MESSAGE('Process Complete');
                    end;
                }
                action("Print Appraisal")
                {
                    ApplicationArea = Basic;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = true;
                    ToolTip = 'Executes the Print Appraisal action.';

                    trigger OnAction()
                    begin
                        App.Reset;
                        App.SetRange(App."Appraisal No", Rec."Appraisal No");
                        if App."Appraisal Stage" = App."appraisal stage"::"Target Setting" then begin
                            Report.RunModal(52006, true, false, App)
                        end;
                    end;
                }
                action("Sup ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Executes the Sup ID action.';
                }
                action("HR Mid YearEvaluation Form A")
                {
                    ApplicationArea = Basic;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the HR Mid YearEvaluation Form A action.';

                    trigger OnAction()
                    begin
                        /*App.RESET;
                         App.SETRANGE(App.User,User);
                         REPORT.RUNMODAL(39003940,TRUE,FALSE,App)
                         */

                    end;
                }
                action("HR Final Evaluation Form A")
                {
                    ApplicationArea = Basic;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the HR Final Evaluation Form A action.';

                    trigger OnAction()
                    begin
                        /*App.RESET;
                         App.SETRANGE(App.User,User);
                         REPORT.RUNMODAL(39003939,TRUE,FALSE,App)*/

                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        //IF Locked=TRUE THEN
        // ERROR('You cannot edit Locked Appraisal');
    end;

    trigger OnOpenPage()
    begin
        //IF "User ID"<>USERID THEN BEGIN
        //  ERROR('You cannot view other user Applications');
        //  END ELSE
        //SETFILTER("User ID",USERID);
    end;

    var
        HREmp: Record "HR-Employee";
        HREmp2: Record "HR-Employee";
        App: Record "HR Appraisal Header - UP";
}

