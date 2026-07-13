query 50040 "Recruiting Officers"
{
    QueryType = Normal;

    elements
    {
        dataitem(Recruiting_Officers; "Recruiting Officers")
        {
            column(No; No) { }
            filter(Name; Name) { }
            filter(Recruitment_Center; "Recruitment Center") { }
            filter(Recruitment_Date; "Recruitment Date") { }
            filter(Corhot; Corhot) { }
            filter(Line_No; "Line No") { }
            filter(Assigned_By; "Assigned By") { }
            filter(Date_Assigned; "Date Assigned") { }
            filter(Type; Type) { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}