page 51281 "HR Employee Card2"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Employee';
    SourceTable = "HR-Employee";
    Editable = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("General Details")
            {
                Caption = 'General Details';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field(Title; Rec.Title)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Title field.';
                }

                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }

                field(Initials; Rec.Initials)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Initials field.';
                }

                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Full Name field.';
                }

                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }

                field("<GlobSal Dimension 1 Code>"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }

                field(Picture; Rec.Picture)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Picture field.';
                }
                field("Employee Type"; Rec."Employee Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employee Type field.';
                }


                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }

                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group("Personal Details")
            {
                Caption = 'Personal Details';
                field(Gender; Rec.Gender)
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Marital Status"; Rec."Marital Status")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Religion field.';
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Persons with Disability? field.';
                }
            }
            group("Communication Details")
            {
                Caption = 'Communication Details';

                field("Cell Phone Number"; Rec."Cell Phone Number")
                {
                    ExtendedDatatype = PhoneNo;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cell Phone Number field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ExtendedDatatype = EMail;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ExtendedDatatype = EMail;

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Company E-Mail field.';
                }
            }

            group("Important Dates")
            {
                Caption = 'Important Dates';
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';

                    trigger OnValidate();
                    begin
                        IF Rec."Date Of Birth" >= TODAY THEN BEGIN
                            ERROR('Date of birth cannot be %1', Rec."Date of Birth");
                        END;
                    end;
                }

            }
            group("Job Details")
            {
                Caption = 'Job Details';

                field("Job ID"; Rec."Job ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }

                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grade field.';
                }

                field("Payroll Posting Group"; Rec."Payroll Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payroll Posting Group field.';
                }

                field("Contract Type"; Rec."Contract Type")
                {
                    Caption = 'Contract Type';

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
            }

            group("Payment Information")
            {
                Caption = 'Payment Information';
                field("TIN No."; Rec."TIN No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field("Pension No."; Rec."Pension No.")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pension No. field.';
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the NHIF No. field.';
                }

                field("Main Bank"; Rec."Main Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }



                field("Branch Bank"; Rec."Branch Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }



                field("Bank Account Number"; Rec."Bank Account Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account Number field.';
                }


            }
            group("Separation Details")
            {
                Caption = 'Separation Details';
                field("Date Of Leaving the Company"; Rec."Date Of Leaving the Company")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Of Leaving the Company field.';
                }
            }
        }
        area(factboxes) { }
    }

    actions
    {
        area(processing) { }
    }

    trigger OnAfterGetRecord();
    begin
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
    end;

    trigger OnModifyRecord(): Boolean;
    var
    begin
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
    end;

    var

}

