Page 51168 "Applicant Hobbies"
{
    PageType = List;
    SourceTable = "HR Applicant Hobbies";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Interests; Rec.Interests)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interests field.';
                }
                field(Hobby; Rec.Hobby)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hobby field.';
                }
                field(CommunityServices; Rec."Community Services")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Community Services field.';
                }
                field(MajorAchievements; Rec."Major Achievements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Major Achievements field.';
                }
                field(UserName; Rec."User Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
                field(LineNo; Rec."Line No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field(ReligiousAffiliation; Rec."Religious Affiliation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Religious Affiliation field.';
                }
                field(AttendingChurch; Rec."Attending Church")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attending Church field.';
                }
                field(ChurchAddress; Rec."Church Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Church Address field.';
                }
                field(PastorsName; Rec."Pastors Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pastors Name field.';
                }
                field(ChurchActivities; Rec."Church Activities")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Church Activities field.';
                }
                field(AcceptChrist; Rec."Accept Christ")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accept Christ field.';
                }
                field(PersonalMinistry; Rec."Personal Ministry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Personal Ministry field.';
                }
                field(ApplicantNames; Rec."Applicant Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applicant Names field.';
                }
            }
        }
    }

    actions { }
}

