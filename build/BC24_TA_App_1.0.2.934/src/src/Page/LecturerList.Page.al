page 50366 "Lecturer List"
{
    Caption = 'Lecturer''s list';
    CardPageID = "Lecturers Units";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "HR-Employee";
    SourceTableView = WHERE(Lecturer = FILTER(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater("Lecturer Details")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Initials field.';
                }

                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Statistics Group Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }

                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Region field.';
                }
                field("Cellular Phone Number"; Rec."Cellular Phone Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cellular Phone Number field.';
                }
                field("Work Phone Number"; Rec."Work Phone Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Work Phone Number field.';
                }
                field("Ext."; Rec."Ext.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Ext. field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Residential Address field.';
                }
                field("Home Phone Number"; Rec."Home Phone Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Home Phone Number field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Lecture Loading")
            {
                Caption = 'Lecture Loading';
                action("Lecturer Units")
                {
                    Caption = 'Lecturer Units';
                    Image = VoidRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Lecturer Units Details";
                    RunPageLink = Lecturer = FIELD("No.");
                    ToolTip = 'Executes the Lecturer Units action.';
                }
            }
        }
    }
}

