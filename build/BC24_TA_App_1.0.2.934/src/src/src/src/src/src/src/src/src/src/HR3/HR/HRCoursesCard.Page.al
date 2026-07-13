page 50294 "HR Courses Card"
{
    Caption = 'HR Training Courses';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "HR Training Courses";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Code field.';
                }
                field("Course Tittle"; Rec."Course Tittle")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Tittle field.';
                }
                field("Course Version"; Rec."Course Version")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Version field.';
                }
                field("Course Version Description"; Rec."Course Version Description")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Version Description field.';
                }
                field("Campus Code"; Rec."Campus Code")
                {
                    Caption = 'Campus';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field("Campus Name"; Rec."Campus Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Campus Name field.';
                }
                field(Department; Rec.Department)
                {
                    Caption = 'Department';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Station Code"; Rec."Station Code")
                {
                    Caption = 'School';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the School field.';
                }

                field("Need Source"; Rec."Need Source")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Need Source field.';
                }
                field("Nature of Training"; Rec."Nature of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Nature of Training field.';
                }
                field("Training Type"; Rec."Training Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Type field.';
                }
                field("No of Participants Required"; Rec."No of Participants Required")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No of Participants Required field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Duration Units"; Rec."Duration Units")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Duration Units field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Quarter Offered"; Rec."Quarter Offered")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quarter Offered field.';
                }
                field("Cost Of Training"; Rec."Cost Of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Provider; Rec.Provider)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Provider field.';
                }
                field("Provider Name"; Rec."Provider Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Provider Name field.';
                }
                field("Closing Status"; Rec."Closing Status")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Closing Status field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Closed field.';
                }
                field("Individual Course"; Rec."Individual Course")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Individual Course field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Mark as Closed/Open")
                {
                    Caption = '&Mark as Closed/Open';
                    Image = CloseDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the &Mark as Closed/Open action.';
                    trigger OnAction()
                    begin
                        if Rec.Closed then begin
                            Rec.Closed := false;
                            Message('Training need :: %1 :: has been Re-Opened', Rec."Course Tittle");
                        end
                        else begin
                            Rec.Closed := true;
                            Message('Training need :: %1 :: has been closed', Rec."Course Tittle");
                            Rec.Modify;
                        end;
                    end;
                }
            }
        }
    }
}

