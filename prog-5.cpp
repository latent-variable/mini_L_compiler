#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>

struct node
{
    node * prev;
    node * next;
    std::string data;

    node(node * p, node * n, const std::string& s)
        :prev(p), next(n), data(s)
    {
    }
};

struct list
{
    node * head;
    node * tail;
    size_t s;

    list()
        :head(0), tail(0), s(0)
    {
    }

    ~list()
    {
        for(node * n = head; n; n = n->next)
            delete n;
    }

    size_t size() const
    {
        return s;
    }

    node * append(const std::string& str)
    {
        if(tail)
        {
            tail = tail->next = new node(tail, 0, str);
            ++s;
        }
        else
        {
            tail = head = new node(0, 0, str);
            ++s;
        }
        return tail;
    }

    node * add_after(node* n, const std::string& str)
    {
        node * a = new node(n, n->next, str);
      //  n->next->prev = a;
        n->next = a;
        a->prev = n;
        ++s;
        return a;
    }

    void remove(node* n)
    {

        if( n->prev != NULL ){
          n->prev->next = n->next;
        }else{
          head = n->next;
        }
        if(n->next != NULL ){
          n->next->prev = n->prev;
        }
        else{
          tail = n->prev;
        }
        delete n;
        --s;


    }

    void print()
    {
        for(node * n = head; n; n = n->next)
            std::cout << n->data << std::endl;
    }
};

int main()
{
    list L;

    node * a = L.append("A");
    node * c = L.append("C");
    node * e = L.append("E");

    L.print();
    std::cout<< L.size()<<std::endl;

    node * b = L.add_after(a, "B");
    node * d = L.add_after(c, "D");
    node * f = L.add_after(e, "F");
    L.print();
    std::cout<< L.size()<<std::endl;

    L.remove(a);
   L.remove(d);

    L.print();
    std::cout<< L.size()<<std::endl;

    return 0;
}
