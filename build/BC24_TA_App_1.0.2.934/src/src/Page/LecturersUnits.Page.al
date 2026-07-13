Page 50094 "Lecturers Units"
{
    PageType = Document;
    SourceTable = "HR-Employee";
    SourceTableView = where(Lecturer = const(true));
    InsertAllowed = false;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Genera)
            {
                Caption = 'General';
                Editable = true;
                field(EmployeeNo; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(CellularPhoneNumber; Rec."Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cellular Phone Number field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field(ContractType; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field(LecturerCategory; Rec."Lecturer Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lecturer Category field.';
                }


                field(Initials; Rec.Initials)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initials field.';
                }
                field(PartTime; Rec."Part Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Part Time field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Status';
                    ToolTip = 'Specifies the value of the Payroll Status field.';
                }
                field("Is HOD"; Rec."Is HOD")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Is HOD field.';
                }
                field(CompanyEMail; Rec."Company E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company E-Mail field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Password field.';
                }


            }
            group(UnitsSubjects)
            {
                Caption = 'Units/Subjects';
                part("Lecturer Units"; "Lecturers Units/Subjects")
                {
                    ApplicationArea = basic;
                    SubPageLink = Lecturer = field("No.");
                }
            }
        }
        area(factboxes)
        {
            part(Control3; "HR-Employee Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Lecturer)
            {
                Caption = 'Lecturer';

                action(EmployeeCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Card';
                    RunObject = Page Employee;
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the Employee Card action.';
                }



                separator(Action1102755004) { }
                action(LecturerAppointmentLetter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecturer Appointment Letter';
                    promoted = true;
                    Image = LedgerBook;
                    PromotedCategory = report;
                    ToolTip = 'Executes the Lecturer Appointment Letter action.';
                    trigger OnAction()
                    var
                        HRemp: Record "HR-Employee";
                    begin
                        HRemp.reset;
                        HRemp.setrange("No.", Rec."No.");
                        if HRemp.find('-') then
                            Report.Run(70135593, true, true, HRemp);
                    end;
                }
                action(LecturerClaim)
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate Parttime Claim';
                    Promoted = true;
                    ToolTip = 'Executes the Generate Parttime Claim action.';
                    trigger OnAction()
                    var
                        //  WebPortal: Codeunit Webportal;
                        SemRec: Record Semesters;
                        ClaimSem: code[20];
                    begin
                        SemRec.reset;
                        SemRec.setrange(SemRec."Current Semester", true);
                        if SemRec.find('-') then begin
                            ClaimSem := Semrec.code;
                        end;
                        //WebPortal.GenerateParttimeClaim("No.", '',0);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Lecturer := true;
    end;
}

