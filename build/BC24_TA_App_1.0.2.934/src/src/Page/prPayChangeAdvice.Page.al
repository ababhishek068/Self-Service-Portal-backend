Page 50275 prPayChangeAdvice
{
    PageType = Card;
    SourceTable = "prBasic pay PCA";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ChangeAdviceSerialNo; Rec."Change Advice Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Change Advice Serial No. field.';
                }
                field(EmployeeCode; Rec."Employee Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(BasicPay; Rec."Basic Pay")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                }
                field(PaysNSSF; Rec."Pays Pension")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pays pension field.';
                }
                field(PaysNHIF; Rec."Pays NHIF")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pays NHIF field.';
                }
                field(PaysPAYE; Rec."Pays PAYE")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pays PAYE field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(PayrollPeriod; Rec."Payroll Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }


                field(TransferAppointmentNo; Rec."Transfer/Appointment No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer/Appointment No field.';
                }
            }
            part(Control6; "prEmployee Trans PCA")
            {
                SubPageLink = "Employee Code" = field("Employee Code"),
                              "Change Advice Serial No." = field("Change Advice Serial No."),
                              "Payroll Period" = field("Payroll Period");
            }
        }
        area(factboxes)
        {
            systempart(Control3; Notes) { }
            systempart(Control2; Links) { }
            systempart(Control1; MyNotes) { }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Approvals action.';
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin


                    //Release the Imprest for Approval
                    Rec.TestField(Status, Rec.Status::Open);
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin

                    Rec.TestField(Status, Rec.Status::"Pending Approval");
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }


            group(ActionGroup26)
            {
                Caption = 'Post';
                // Visible = false;
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post The Changes';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = true;
                    ToolTip = 'Executes the Post The Changes action.';

                    trigger OnAction()
                    begin
                        if Rec.Status <> Rec.Status::Approved then Error('Pay Change Advice must be approved to continue');

                        //Get
                        mPayrollCode := '';
                        dim1 := '';
                        dim2 := '';
                        dim3 := '';
                        dim4 := '';

                        //-------------------------------------------
                        mPayrollCode := '';

                        UserSetup.Reset;
                        UserSetup.SetRange(UserSetup."User ID", UserId);
                        if UserSetup.Find('-') then begin
                            //  mPayrollCode := UserSetup."Payroll Code";
                        end;

                        objEmp.Reset;
                        objEmp.SetRange(objEmp."No.", Rec."Employee Code");
                        if objEmp.Find('-') then begin
                            // mPayrollCode:=objEmp."Payroll Code";
                            dim1 := objEmp.Campus;
                            dim2 := objEmp."Department Code";
                            // dim3 := objEmp.Schools;
                            // dim4 := objEmp.Section;
                        end;

                        objPayrollPeriod.Reset;
                        objPayrollPeriod.SetRange(objPayrollPeriod.Closed, false);
                        if objPayrollPeriod.Find('-') then begin
                            intMonth := objPayrollPeriod."Period Month";
                            intYear := objPayrollPeriod."Period Year";
                            dtPAyrollPeriod := objPayrollPeriod."Date Opened";
                        end;

                        if Confirm('Are you Sure you want to post these change for employee ' + Rec."Employee Code" + '-' + Rec."Employee Name") then begin
                            /* objEmpTrans.RESET;
                             objEmpTrans.SETRANGE(objEmpTrans."Employee Code","Employee Code");
                             objEmpTrans.SETRANGE(objEmpTrans."Payroll Period","Payroll Period");
                             IF objEmpTrans.FIND('-') THEN
                             BEGIN
                              objEmpTrans.DELETEALL(TRUE);
                             END;
                            */

                            objSalCard.Reset;
                            objSalCard.SetRange(objSalCard."Employee Code", Rec."Employee Code");
                            if objSalCard.Find('-') then begin //-------------if old employee then Check changes to the basic pay and update-------------
                                objSalCard."Basic Pay" := Rec."Basic Pay";
                                objSalCard."Pays Pension" := Rec."Pays Pension";
                                objSalCard."Pays NHIF" := Rec."Pays NHIF";
                                objSalCard."Pays PAYE" := Rec."Pays PAYE";

                                Rec.Effected := true;
                                objSalCard.Modify;
                                fnTrackChanges('Change in Basic Salary', Format(xRec."Basic Pay"), Format(Rec."Basic Pay"));
                            end else begin                     //-------------if new employee insert prsalary card---------------------------------------
                                objSalCard.Init;
                                objSalCard."Employee Code" := Rec."Employee Code";
                                objSalCard."Basic Pay" := Rec."Basic Pay";
                                objSalCard."Payment Mode" := objSalCard."payment mode"::"Bank Transfer";
                                objSalCard."Pays Pension" := true;
                                objSalCard."Pays NHIF" := true;
                                objSalCard."Pays PAYE" := true;
                                objSalCard."Suspend Pay" := false;
                                objSalCard."Suspension Date" := 0D;
                                objSalCard."Suspension Reasons" := '';
                                // objSalCard.Pos := 'PAYROLL';

                                objSalCard.Insert;
                                fnTrackChanges('Change in Basic Salary', Format(xRec."Basic Pay"), Format(Rec."Basic Pay"));
                            end;
                            //-------------if transaction is new insert new-------------------------------------------
                            objEmpTransPCA.Reset;
                            objEmpTransPCA.SetRange(objEmpTransPCA."Employee Code", Rec."Employee Code");
                            objEmpTransPCA.SetRange(objEmpTransPCA."Payroll Period", Rec."Payroll Period");
                            objEmpTransPCA.SetRange(objEmpTransPCA."Change Advice Serial No.", Rec."Change Advice Serial No.");
                            if objEmpTransPCA.Find('-') then begin
                                repeat
                                begin

                                    dim1 := objEmpTransPCA."Global Dimension 1 Code";
                                    dim2 := objEmpTransPCA."Global Dimension 2 Code";
                                    dim3 := objEmpTransPCA."Shortcut Dimension 3 Code";
                                    dim4 := objEmpTransPCA."Shortcut Dimension 4 Code";

                                    if dim1 = '' then dim1 := objEmp.Campus;
                                    if dim2 = '' then dim2 := objEmp."Department Code";
                                    // if dim3 = '' then dim3 := objEmp.Schools;
                                    // if dim4 = '' then dim4 := objEmp.Section;

                                    /*objEmpTrans.RESET;
                                    objEmpTrans.SETRANGE(objEmpTrans."Employee Code",objEmpTransPCA."Employee Code");
                                    objEmpTrans.SETRANGE(objEmpTrans."Payroll Period",objEmpTransPCA."Payroll Period");
                                    objEmpTrans.SETRANGE(objEmpTrans."Transaction Code",objEmpTransPCA."Transaction Code");
                                    objEmpTrans.SETRANGE(objEmpTrans."Payroll Code",mPayrollCode);
                           //         objEmpTrans.SETRANGE(objEmpTrans."Global Dimension 2 Code",dim2);
                                    IF objEmpTrans.FIND('-') THEN BEGIN
                             //         objEmpTrans.CALCFIELDS(objEmpTrans."PI Approval Status");
                             //          IF objEmpTrans."PI Approval Status"<>objEmpTrans."PI Approval Status"::Open THEN ERROR('You cannot post changes to since the is NOT open');
                                    END; */

                                    objEmpTrans.Reset;
                                    objEmpTrans.SetRange(objEmpTrans."Employee Code", objEmpTransPCA."Employee Code");
                                    objEmpTrans.SetRange(objEmpTrans."Payroll Period", objEmpTransPCA."Payroll Period");
                                    objEmpTrans.SetRange(objEmpTrans."Transaction Code", objEmpTransPCA."Transaction Code");
                                    // objEmpTrans.SetRange(objEmpTrans."Payroll Code", mPayrollCode);
                                    if objEmpTrans.Find('-') then begin
                                        objEmpTrans."Employee Code" := objEmpTransPCA."Employee Code";
                                        objEmpTrans."Transaction Code" := objEmpTransPCA."Transaction Code";
                                        objEmpTrans."Period Month" := intMonth;
                                        objEmpTrans."Period Year" := intYear;
                                        objEmpTrans."Payroll Period" := dtPAyrollPeriod;
                                        objEmpTrans."Transaction Name" := objEmpTransPCA."Transaction Name";
                                        objEmpTrans.Amount := objEmpTransPCA.Amount;
                                        objEmpTrans.Balance := objEmpTransPCA.Balance;
                                        objEmpTrans."Payroll Period" := objEmpTransPCA."Payroll Period";
                                        // objEmpTrans."Payroll Code" := mPayrollCode;
                                        //objEmpTrans."Global Dimension 1 Code":=dim1;
                                        //objEmpTrans."Global Dimension 2 Code":=dim2;
                                        //objEmpTrans."Shortcut Dimension 3 Code":=dim3;
                                        //objEmpTrans."Shortcut Dimension 4 Code":=dim4;
                                        objEmpTrans."Start Date" := objEmpTransPCA."Start Date";
                                        objEmpTrans."End Date" := objEmpTransPCA."End Date";
                                        objEmpTrans.Modify;
                                    end else begin
                                        objEmpTrans.Init;
                                        objEmpTrans."Employee Code" := objEmpTransPCA."Employee Code";
                                        objEmpTrans."Transaction Code" := objEmpTransPCA."Transaction Code";
                                        objEmpTrans."Period Month" := intMonth;
                                        objEmpTrans."Period Year" := intYear;
                                        objEmpTrans."Payroll Period" := dtPAyrollPeriod;
                                        objEmpTrans."Transaction Name" := objEmpTransPCA."Transaction Name";
                                        objEmpTrans.Amount := objEmpTransPCA.Amount;
                                        objEmpTrans.Balance := objEmpTransPCA.Balance;
                                        objEmpTrans."Payroll Period" := objEmpTransPCA."Payroll Period";
                                        // objEmpTrans."Payroll Code" := mPayrollCode;
                                        //objEmpTrans."Global Dimension 1 Code":=dim1;
                                        //objEmpTrans."Global Dimension 2 Code":=dim2;
                                        //objEmpTrans."Shortcut Dimension 3 Code":=dim3;
                                        //objEmpTrans."Shortcut Dimension 4 Code":=dim4;
                                        objEmpTrans."Start Date" := objEmpTransPCA."Start Date";
                                        objEmpTrans."End Date" := objEmpTransPCA."End Date";
                                        objEmpTrans.Insert;
                                    end;
                                end;
                                until objEmpTransPCA.Next = 0;
                            end;

                            Rec.Effected := true;
                            Rec.Status := Rec.Status::Posted;

                            Rec.Modify;

                            Message('The changes has been uploaded to the current payroll');
                        end;

                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Status <> Rec.Status::Open then Error('You cannot modify a PCA if status is not open');
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed, false);
        if objPeriod.Find('-') then begin
            Rec."Payroll Period" := objPeriod."Date Opened";
            //:=objPeriod."Period Name";
            Rec."Period Month" := objPeriod."Period Month";
            Rec."Period Year" := objPeriod."Period Year";
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Status <> Rec.Status::Open then Error('You cannot modify a PCA if status is not open');
    end;

    var
        objPeriod: Record "pr Payroll Periods";
        mPayrollCode: Code[50];
        objEmp: Record "HR-Employee";
        objSalCard: Record "pr Salary Card";
        objEmpTrans: Record "pr Employee Transactions";
        objEmpTransPCA: Record "prEmployee Trans PCA";
        objPayrollPeriod: Record "pr Payroll Periods";
        intMonth: Integer;
        intYear: Integer;
        dtPAyrollPeriod: Date;
        dim1: Code[50];
        dim2: Code[50];
        dim3: Code[50];
        dim4: Code[50];
        UserSetup: Record "User Setup";

    procedure fnTrackChanges(columnss: Code[250]; oldValue: Code[250]; NewValue: Code[250])
    var
        HRtracker: Record "HR Change Entries";
    begin
        HRtracker.Init;
        HRtracker."employee No" := Rec."Employee Code";
        HRtracker."Change Date" := Today;
        HRtracker."Change Description" := columnss;
        HRtracker."Old Value" := oldValue;
        HRtracker."New Value" := NewValue;
        HRtracker.UserID := UserId;
        HRtracker.Insert;
    end;
}

