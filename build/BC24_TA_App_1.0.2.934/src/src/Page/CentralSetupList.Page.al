page 50341 "Central Setup List"
{
    PageType = List;
    SourceTable = "Supplier Portal Central Setups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Agpo; Rec.Agpo)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Agpo field.';
                }
                field(General; Rec.General)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the General field.';
                }
            }
        }
    }
}