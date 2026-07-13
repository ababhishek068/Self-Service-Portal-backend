tableextension 50032 "Document Attachment Ext" extends "Document Attachment"
{
    fields
    {
        field(50000; "Document Category"; Enum "Doc. Attachment Cateogory") { }
        field(50001; "Document Description"; Text[200]) { }
        field(50002; Current; Boolean)
        {
            Description = 'Current is marked active when there is more than one attached document for a particular HR document download';
        }
    }
}