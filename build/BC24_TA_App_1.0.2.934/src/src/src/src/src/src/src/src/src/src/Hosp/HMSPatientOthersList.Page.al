page 51321 "HMS Patient Others List"
{
    CardPageID = "HMS Patient Others Card";
    PageType = List;
    SourceTable = "HMS Patient";
    SourceTableView = WHERE(Blocked = FILTER(false),
                            "Patient Type" = FILTER(<> Student | Employee));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater("Personal details")
            {
                Caption = 'Personal details';
                Editable = true;
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Patient Type field.';

                    trigger OnValidate()
                    begin
                        CheckPatientType();
                    end;
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
                field("Surname+' '+""Middle Name""+' '+""Last Name"""; Rec.Surname + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name")
                {
                    ShowCaption = false;
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
            repeater("Medical details")
            {
                Caption = 'Medical details';
                Editable = true;
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
        }
    }

    actions
    {
        area(processing)
        {
            action(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "HMS Patient Card";
                RunPageLink = "Patient No." = FIELD("Patient No.");
                ToolTip = 'Executes the Statistics action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Relative No.Enable" := true;
        "Employee No.Enable" := true;
        "Student No.Enable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Patient Type" := Rec."Patient Type"::Private;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CheckPatientType();
        if Rec."Date Of Birth" <> 0D then begin
            Age := HRDates.DetermineAge(Rec."Date Of Birth", Today);
        end;
    end;
}

