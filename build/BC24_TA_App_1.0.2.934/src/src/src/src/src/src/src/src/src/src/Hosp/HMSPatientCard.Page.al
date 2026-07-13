page 50410 "HMS Patient Card"
{
    PageType = Card;
    SourceTable = "HMS Patient";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Personal details")
            {
                Caption = 'Personal details';
                Editable = false;
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Date Registered"; Rec."Date Registered")
                {
                    ToolTip = 'Specifies the value of the Date Registered field.';
                }
                field("Patient Type"; Rec."Patient Type")
                {
                    ToolTip = 'Specifies the value of the Patient Type field.';

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
                }
                field("Student No."; Rec."Student No.")
                {
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Relative No."; Rec."Relative No.")
                {
                    ToolTip = 'Specifies the value of the Relative No. field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the value of the First/English Name field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field("Insurance No."; Rec."Insurance No.")
                {
                    ToolTip = 'Specifies the value of the Insurance No. field.';
                }
                field("Insurance Name"; Rec."Insurance Name")
                {
                    ToolTip = 'Specifies the value of the Insurance Name field.';
                }
                field("Membership No"; Rec."Membership No")
                {
                    ToolTip = 'Specifies the value of the Membership No field.';
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ToolTip = 'Specifies the value of the Date Of Birth field.';

                    trigger OnValidate()
                    begin
                        if Rec."Date Of Birth" <> 0D then begin
                            Age := HRDates.DetermineAge(Rec."Date Of Birth", Today);
                        end;
                    end;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field("ID Number"; Rec."ID Number")
                {
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Age; Age)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(Photo; Rec.Photo)
                {
                    ToolTip = 'Specifies the value of the Photo field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
            }
            group("Medical details")
            {
                Caption = 'Medical details';
                Editable = false;
                field("Examining Officer"; Rec."Examining Officer")
                {
                    ToolTip = 'Specifies the value of the Examining Officer field.';
                }
                field("Medical Exam Date"; Rec."Medical Exam Date")
                {
                    ToolTip = 'Specifies the value of the Medical Exam Date field.';
                }
                field("Medical Details Not Covered"; Rec."Medical Details Not Covered")
                {
                    ToolTip = 'Specifies the value of the Medical Details Not Covered field.';
                }
                field(Height; Rec.Height)
                {
                    ToolTip = 'Specifies the value of the Height field.';
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.';
                }


                field("Physical Impairment Details"; Rec."Physical Impairment Details")
                {
                    ToolTip = 'Specifies the value of the Physical Impairment Details field.';
                }
                field("Blood Group"; Rec."Blood Group")
                {
                    ToolTip = 'Specifies the value of the Blood Group field.';
                }
                field("Without Glasses R.6"; Rec."Without Glasses R.6")
                {
                    ToolTip = 'Specifies the value of the Without Glasses R.6 field.';
                }
                field("Without Glasses L.6"; Rec."Without Glasses L.6")
                {
                    ToolTip = 'Specifies the value of the Without Glasses L.6 field.';
                }
                field("With Glasses R.6"; Rec."With Glasses R.6")
                {
                    ToolTip = 'Specifies the value of the With Glasses R.6 field.';
                }
                field("With Glasses L.6"; Rec."With Glasses L.6")
                {
                    ToolTip = 'Specifies the value of the With Glasses L.6 field.';
                }
                field("Hearing Right Ear"; Rec."Hearing Right Ear")
                {
                    ToolTip = 'Specifies the value of the Hearing Right Ear field.';
                }
                field("Hearing Left Ear"; Rec."Hearing Left Ear")
                {
                    ToolTip = 'Specifies the value of the Hearing Left Ear field.';
                }
                field("Condition Of Teeth"; Rec."Condition Of Teeth")
                {
                    ToolTip = 'Specifies the value of the Condition Of Teeth field.';
                }
                field("Condition Of Throat"; Rec."Condition Of Throat")
                {
                    ToolTip = 'Specifies the value of the Condition Of Throat field.';
                }
                field("Condition Of Ears"; Rec."Condition Of Ears")
                {
                    ToolTip = 'Specifies the value of the Condition Of Ears field.';
                }
                field("Condition Of Lymphatic Glands"; Rec."Condition Of Lymphatic Glands")
                {
                    ToolTip = 'Specifies the value of the Condition Of Lymphatic Glands field.';
                }
                field("Condition Of Nose"; Rec."Condition Of Nose")
                {
                    ToolTip = 'Specifies the value of the Condition Of Nose field.';
                }
                field("Circulatory System Pulse"; Rec."Circulatory System Pulse")
                {
                    ToolTip = 'Specifies the value of the Circulatory System Pulse field.';
                }
            }
            group(Appointments)
            {
                // Caption = 'Appointments';
                // Editable = false;
                // part(Control1102760114; "HR Employees Kin")
                // {
                //     SubPageLink = "Employee Code" = FIELD("Patient No.");
                // }
            }
            group(Observation)
            {
                Caption = 'Observation';
                Editable = false;
                part(Control1102760115; "HMS Observation SubForm")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group(Treatment)
            {
                Caption = 'Treatment';
                Editable = false;
                part(Control1102760118; "HMS Treatment SubForm")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group(Laboratory)
            {
                Caption = 'Laboratory';
                Editable = false;
                part(Control1102760116; "HMS Laboratory SubForm")
                {
                    Editable = false;
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group(Radiology)
            {
                Caption = 'Radiology';
                Editable = false;
                part(Control1102760117; "HMS Radiology SubForm")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group(Pharmacy)
            {
                Caption = 'Pharmacy';
                Editable = false;
                part(Control1102760119; "HMS Pharmacy SubForm")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group(Admission)
            {
                Caption = 'Admission';
                Editable = false;
                part(Control1102760120; "HMS Admission SubForm")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group(Referrals)
            {
                Caption = 'Referrals';
                Editable = false;
                part(Control1102760121; "HMS Referral SubForm")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group("Historical Medical Conditions")
            {
                Caption = 'Historical Medical Conditions';
                Editable = false;
                part(Control1102760127; "HMS Patient Medical Condition")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group("Historical Immunizations")
            {
                Caption = 'Historical Immunizations';
                Editable = false;
                part(Control1102760126; "HMS Patient Immunization")
                {
                    SubPageLink = "Patient No." = FIELD("Patient No.");
                }
            }
            group("Spouse details (If Married)")
            {
                Caption = 'Spouse details (If Married)';
                Editable = false;
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ToolTip = 'Specifies the value of the Spouse Name field.';
                }
                field("Spouse Address 1"; Rec."Spouse Address 1")
                {
                    ToolTip = 'Specifies the value of the Spouse Address 1 field.';
                }
                field("Spouse Address 2"; Rec."Spouse Address 2")
                {
                    ToolTip = 'Specifies the value of the Spouse Address 2 field.';
                }
                field("Spouse Address 3"; Rec."Spouse Address 3")
                {
                    ToolTip = 'Specifies the value of the Spouse Address 3 field.';
                }
                field("Spouse Telephone No. 1"; Rec."Spouse Telephone No. 1")
                {
                    ToolTip = 'Specifies the value of the Spouse Telephone No. 1 field.';
                }
                field("Spouse Telephone No. 2"; Rec."Spouse Telephone No. 2")
                {
                    ToolTip = 'Specifies the value of the Spouse Telephone No. 2 field.';
                }
                field("Spouse Email"; Rec."Spouse Email")
                {
                    ToolTip = 'Specifies the value of the Spouse Email field.';
                }
                field("Spouse Fax"; Rec."Spouse Fax")
                {
                    ToolTip = 'Specifies the value of the Spouse Fax field.';
                }
            }
            group("Correspondence Address")
            {
                Caption = 'Correspondence Address';
                Editable = false;
                field("Place of Birth Village"; Rec."Place of Birth Village")
                {
                    ToolTip = 'Specifies the value of the Place of Birth Village field.';
                }
                field("Place of Birth Location"; Rec."Place of Birth Location")
                {
                    ToolTip = 'Specifies the value of the Place of Birth Location field.';
                }
                field("Place of Birth District"; Rec."Place of Birth District")
                {
                    ToolTip = 'Specifies the value of the Place of Birth District field.';
                }
                field("Name of Chief"; Rec."Name of Chief")
                {
                    ToolTip = 'Specifies the value of the Name of Chief field.';
                }
                field("Nearest Police Station"; Rec."Nearest Police Station")
                {
                    ToolTip = 'Specifies the value of the Nearest Police Station field.';
                }
                field("Correspondence Address 1"; Rec."Correspondence Address 1")
                {
                    ToolTip = 'Specifies the value of the Correspondence Address 1 field.';
                }
                field("Correspondence Address 2"; Rec."Correspondence Address 2")
                {
                    ToolTip = 'Specifies the value of the Correspondence Address 2 field.';
                }
                field("Correspondence Address 3"; Rec."Correspondence Address 3")
                {
                    ToolTip = 'Specifies the value of the Correspondence Address 3 field.';
                }
                field("Telephone No. 1"; Rec."Telephone No. 1")
                {
                    ToolTip = 'Specifies the value of the Telephone No. 1 field.';
                }
                field("Telephone No. 2"; Rec."Telephone No. 2")
                {
                    ToolTip = 'Specifies the value of the Telephone No. 2 field.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. field.';
                }
            }
            group("Parent Details")
            {
                Caption = 'Parent Details';
                Editable = false;
                field("Mother Alive or Dead"; Rec."Mother Alive or Dead")
                {
                    ToolTip = 'Specifies the value of the Mother Alive or Dead field.';
                }
                field("Mother Full Name"; Rec."Mother Full Name")
                {
                    ToolTip = 'Specifies the value of the Mother Full Name field.';
                }
                field("Mother Occupation"; Rec."Mother Occupation")
                {
                    ToolTip = 'Specifies the value of the Mother Occupation field.';
                }
                field("Father Alive or Dead"; Rec."Father Alive or Dead")
                {
                    ToolTip = 'Specifies the value of the Father Alive or Dead field.';
                }
                field("Father Full Name"; Rec."Father Full Name")
                {
                    ToolTip = 'Specifies the value of the Father Full Name field.';
                }
                field("Father Occupation"; Rec."Father Occupation")
                {
                    ToolTip = 'Specifies the value of the Father Occupation field.';
                }
                field("Guardian Name"; Rec."Guardian Name")
                {
                    ToolTip = 'Specifies the value of the Guardian Name field.';
                }
                field("Guardian Occupation"; Rec."Guardian Occupation")
                {
                    ToolTip = 'Specifies the value of the Guardian Occupation field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        //OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        /*
        "Relative No.Enable" := TRUE;
        "Employee No.Enable" := TRUE;
        "Student No.Enable" := TRUE;
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //OnAfterGetCurrRecord;
    end;

    var
        HRDates: Codeunit "HR Dates";
        Age: Text[100];
        [InDataSet]
        "Student No.Enable": Boolean;
        [InDataSet]
        "Employee No.Enable": Boolean;
        [InDataSet]
        "Relative No.Enable": Boolean;

    procedure CheckPatientType()
    begin
        if Rec."Patient Type" = Rec."Patient Type"::Private then begin
            "Student No.Enable" := true;
            "Employee No.Enable" := false;
            "Relative No.Enable" := false;
        end
        else begin
            "Student No.Enable" := false;
            "Employee No.Enable" := true;
            "Relative No.Enable" := true;
        end;
    end;


}

