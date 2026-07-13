tableextension 50041 "Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Approval Status"; option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved;
        }
    }
}