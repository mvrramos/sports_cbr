import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/custom_drawer/custom_drawer.dart';
import '../../models/home_manager.dart';
import '../../models/user/user_manager.dart';
import 'components/add_section_widget.dart';
import 'components/section_list.dart';
import 'components/section_staggared.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            elevation: 0,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: const Text("Sports CBR"),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/cart'),
                icon: const Icon(Icons.shopping_cart),
              ),
              Consumer2<UserManager, HomeManager>(
                builder: (_, userManager, homeManager, __) {
                  if (userManager.adminEnabled && !homeManager.loading) {
                    if (homeManager.editing) {
                      return PopupMenuButton(onSelected: (e) {
                        if (e == 'Salvar') {
                          homeManager.saveEditing();
                        } else {
                          homeManager.discardEditing();
                        }
                      }, itemBuilder: (_) {
                        return [
                          'Salvar',
                          'Descartar'
                        ].map((e) {
                          return PopupMenuItem(value: e, child: Text(e));
                        }).toList();
                      });
                    } else {
                      return IconButton(
                        onPressed: homeManager.enterEditing,
                        icon: const Icon(Icons.edit),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
          Consumer<HomeManager>(
            builder: (_, homeManager, __) {
              if (homeManager.loading) {
                return const SliverToBoxAdapter(
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color.fromARGB(200, 73, 5, 182)),
                    backgroundColor: Colors.transparent,
                  ),
                );
              }
              final List<Widget> children = homeManager.sections.map<Widget>((section) {
                switch (section.type) {
                  case 'Staggered':
                    return SectionStaggared(section);
                  case 'List':
                    return SectionList(section);
                  default:
                    return Container();
                }
              }).toList();

              if (homeManager.editing) {
                children.add(AddSectionWidget(homeManager));
              }
              return SliverList(
                delegate: SliverChildListDelegate(children),
              );
            },
          )
        ],
      ),
    );
  }
}
